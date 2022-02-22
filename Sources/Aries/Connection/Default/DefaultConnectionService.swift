//
// Copyright 2022 Bundesrepublik Deutschland
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
// the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
// an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//

import Indy
import IndyObjc
import Darwin

/// Implementation of did exchange based on Indy functionalities.
class DefaultConnectionService: ConnectionService {

	private let recordService: RecordService
	private let provisioningService: ProvisioningService

	init(
		recordService: RecordService,
		provisioningService: ProvisioningService
	) {
		self.recordService = recordService
		self.provisioningService = provisioningService
	}

	// MARK: - Flow As Initiator

	func createInvitation(
        for configuration: InvitationConfiguration,
        with context: Context
	) async throws -> (ConnectionInvitationMessage, ConnectionRecord) {
        guard let handle = context.wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

		let key = try await Crypto.createKey(in: handle)

		// Setup record
		var connection = ConnectionRecord(id: configuration.connectionId)
		connection.multiParty = configuration.multiParty
		connection.alias = connection.multiParty ? nil : configuration.theirAlias
		connection.tags[Tags.connectionKey] = key

		if configuration.autoAccept {
			connection.tags[Tags.autoAccept] = "True"
		}

		if !configuration.multiParty && configuration.theirAlias?.name?.isEmpty == false {
			connection.tags[Tags.alias] = configuration.theirAlias?.name
		}

		for (key, value) in configuration.tags {
			connection.tags[key] = value
		}

        let provisioning = try await provisioningService.getRecord(with: context)

		guard provisioning.endpoint?.uri.isEmpty == false else {
			throw AriesError.notFound("Provisioning Endpoint")
		}

        try await recordService.add(connection, to: context.wallet)

		// TODO: Use DID utility
		let routingKeys: [String]
		if configuration.useDidKeyFormat {
			routingKeys = provisioning.endpoint?.verkeys
				.filter { _ in true /* isFullVerkey */ }
				.map { _ in "" /* Convert verkey to didkey */ } ?? []
		} else {
			routingKeys = provisioning.endpoint?.verkeys ?? []
		}

		// TODO: Use DID utility
		let recipientKey = configuration.useDidKeyFormat ? key /* Convert verkey to didkey */ : key

		let message = ConnectionInvitationMessage(
			label: configuration.myAlias?.name ?? provisioning.owner?.name,
			imageUrl: configuration.myAlias?.imageUrl ?? provisioning.owner?.imageUrl,
			endpoint: provisioning.endpoint?.uri ?? "",
			routingKeys: routingKeys,
			recipientKeys: [recipientKey]
		)

		return (message, connection)
	}

    func revokeInvitation(for connectionId: String, with context: Context) async throws {
        let record = try await recordService.get(ConnectionRecord.self, for: connectionId, from: context.wallet)

		guard record.state == .invited else {
            throw AriesError.illegalState("Expected \(ConnectionState.invited), found: \(record.state)")
		}

        try await recordService.delete(ConnectionRecord.self, with: connectionId, in: context.wallet)
	}

	func processRequest(
        _ message: ConnectionRequestMessage,
        with record: ConnectionRecord,
        _ context: Context
	) async throws -> String {
        guard let handle = context.wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

		let (did, verkey) = try await Did.createAndStore(in: handle)

		var record = record
		record.myDid = did
		record.myVerkey = verkey
		record.theirDid = message.connection.did
		record.theirVerkey = message.connection.document?.keys?.first?.key
		record.tags[Tags.lastThreadId] = message.id

		if record.alias == nil, message.label?.isEmpty == false
			|| message.imageUrl?.isEmpty == false {
			record.alias = ConnectionAlias(
				name: message.label,
				imageUrl: message.imageUrl
			)
		}

		if !record.multiParty {
			record.state = .negotiating

            try await recordService.update(record, in: context.wallet)

			return record.id
		} else {
			var new = ConnectionRecord()
			new.myDid = record.myDid
			new.myVerkey = record.myVerkey
			new.theirDid = record.theirDid
			new.theirVerkey = record.theirVerkey
			new.multiParty = false
			new.alias = record.alias
			new.endpoint = record.endpoint
			new.state = .negotiating
			new.tags = record.tags

            try await recordService.add(new, to: context.wallet)

			return new.id
		}
	}

	func createResponse(
        for id: String,
        with context: Context
	) async throws -> (ConnectionResponseMessage, ConnectionRecord) {

		// Update record
        var record = try await recordService.get(ConnectionRecord.self, for: id, from: context.wallet)
		guard record.state == .negotiating else {
            throw AriesError.illegalState("Expected \(ConnectionState.negotiating), found \(record.state)")
		}
		record.state = .connected
        try await recordService.update(record, in: context.wallet)

		// Create response
        let provisioning = try await provisioningService.getRecord(with: context)
		let connection = Connection(
			did: record.myDid ?? "",
			document: record.myDocument(for: provisioning)
		)

		let key = record.tags[Tags.connectionKey] ?? ""
		let data = try JSONEncoder.shared.encode(connection)
        let signature = try await SignatureUtil.sign(data, with: key, context.wallet)

		let response = ConnectionResponseMessage(
			signature: signature
		)

		return (response, record)
	}

	// MARK: - Flow as Receiver

	func createRequest(
        for invitation: ConnectionInvitationMessage,
        with context: Context
	) async throws -> (ConnectionRequestMessage, ConnectionRecord) {
        guard let handle = context.wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

        // Create a new DID and verkey for this connection
		let (did, verkey) = try await Did.createAndStore(in: handle)

		// Setup record
        var record = ConnectionRecord(id: invitation.id)
		record.myDid = did
		record.myVerkey = verkey
		record.state = .negotiating
		record.endpoint = Endpoint(
            uri: invitation.endpoint,
            did: nil,
            verkeys: invitation.routingKeys ?? []
		)
		if invitation.label?.isEmpty == false || invitation.imageUrl?.isEmpty == false {
			record.alias = ConnectionAlias(
				name: invitation.label,
				imageUrl: invitation.imageUrl
			)
		}
		if let recipientKey = invitation.recipientKeys.first {
			record.tags["InvitationKey"] = recipientKey
		}

		// Create request
        let provisioning = try await provisioningService.getRecord(with: context)
        let connection = Connection(
            did: record.myDid ?? "",
            document: record.myDocument(for: provisioning)
        )
		let request = ConnectionRequestMessage(
            id: invitation.id,
            label: provisioning.owner?.name,
            imageUrl: provisioning.owner?.imageUrl,
            connection: connection
		)

		// TODO: Also add image as attachment

        try await recordService.add(record, to: context.wallet)

		return (request, record)
	}

	func processResponse(
        _ message: ConnectionResponseMessage,
        with record: ConnectionRecord,
        _ context: Context
	) async throws -> String {
        guard let handle = context.wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

		// Investigate connection
		let data = try await SignatureUtil.verify(message.signature)
		let json = String(bytes: data, encoding: .utf8) ?? ""
		let connection: Connection = try JSONDecoder.shared.model(json)
		let theirDid = connection.did
        let theirVerkey = connection.document?.keys?.first?.key

		// Store their DID
		try await Did.storeTheirDid(
			with: .foreign(did: theirDid, verkey: theirVerkey),
			in: handle
		)

		// Update record
		var record = record
		record.theirDid = theirDid
		record.theirVerkey = theirVerkey
		record.state = .connected
		// record.tags[Tags.lastThreadId] = "message.threadId"
        if let endpoint = connection.document?.services?.first, let routingKeys = endpoint.routingKeys {
			record.endpoint = Endpoint(
                uri: endpoint.endpoint,
                did: connection.did,
                verkeys: routingKeys
			)
		}

        try await recordService.update(record, in: context.wallet)

		return record.id
	}
}
