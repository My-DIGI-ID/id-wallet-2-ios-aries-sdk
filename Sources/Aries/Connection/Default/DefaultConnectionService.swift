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
		with wallet: Wallet,
		_ configuration: InvitationConfiguration
	) async throws -> (ConnectionInvitationMessage, ConnectionRecord) {
		guard let handle = wallet as? IndyHandle else {
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

		// TODO: Replace with mediator information
		let provisioning = try await provisioningService.getRecord(from: wallet)

		guard provisioning.endpoint?.uri.isEmpty == false else {
			throw AriesError.notFound("Provisioning Endpoint")
		}

		try await recordService.add(connection, to: wallet)

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

	func revokeInvitation(for connectionId: String, in wallet: Wallet) async throws {
        let record = try await recordService.get(ConnectionRecord.self, for: connectionId, from: wallet)

		guard record.state == .invited else {
            throw AriesError.illegalState("Expected \(ConnectionState.invited), found: \(record.state)")
		}

        try await recordService.delete(ConnectionRecord.self, with: connectionId, in: wallet)
	}

	func processRequest(
		_ message: ConnectionRequestMessage,
		with record: ConnectionRecord,
		in wallet: Wallet
	) async throws -> String {
		guard let handle = wallet as? IndyHandle else {
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

			try await recordService.update(record, in: wallet)

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

			try await recordService.add(new, to: wallet)

			return new.id
		}
	}

	func createResponse(
		for id: String,
		in wallet: Wallet
	) async throws -> (ConnectionResponseMessage, ConnectionRecord) {

		// Update record
        var record = try await recordService.get(ConnectionRecord.self, for: id, from: wallet)
		guard record.state == .negotiating else {
            throw AriesError.illegalState("Expected \(ConnectionState.negotiating), found \(record.state)")
		}
		record.state = .connected
		try await recordService.update(record, in: wallet)

		// Create response
		// TODO: Replace with mediator information
		let provisioning = try await provisioningService.getRecord(from: wallet)
		let connection = Connection(
			did: record.myDid ?? "",
			document: record.myDocument(for: provisioning)
		)

		let key = record.tags[Tags.connectionKey] ?? ""
		let data = try JSONEncoder.shared.encode(connection)
		let signature = try await SignatureUtil.sign(data, with: key, wallet)

		// TODO: Add Thread decorator when implemented
		// let threadId = record.tags[Tags.lastThreadId]

		let response = ConnectionResponseMessage(
			signature: signature
		)

		return (response, record)
	}

	// MARK: - Flow as Receiver

	func createRequest(
		for invitation: ConnectionInvitationMessage,
		with wallet: Wallet
	) async throws -> (ConnectionRequestMessage, ConnectionRecord) {
		guard let handle = wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

		let (did, verkey) = try await Did.createAndStore(in: handle)

        let routingKeys: [String]?
        if let keys = invitation.routingKeys, !keys.isEmpty {
            routingKeys = keys
        } else {
            routingKeys = nil
        }

		// Setup record
		var connection = ConnectionRecord()
		connection.myDid = did
		connection.myVerkey = verkey
		connection.state = .negotiating
		connection.endpoint = Endpoint(
			uri: invitation.endpoint,
			did: nil,
            verkeys: routingKeys ?? []
		)
		if invitation.label?.isEmpty == false || invitation.imageUrl?.isEmpty == false {
			connection.alias = ConnectionAlias(
				name: invitation.label,
				imageUrl: invitation.imageUrl
			)
		}
		if let recipientKey = invitation.recipientKeys.first {
			connection.tags["InvitationKey"] = recipientKey
		}

		// Create request
		// TODO: Replace with mediator information
		let provisioning = try await provisioningService.getRecord(from: wallet)
		let request = ConnectionRequestMessage(
			label: provisioning.owner?.name,
			imageUrl: provisioning.owner?.imageUrl,
			connection: Connection(
				did: connection.myDid ?? "",
				document: connection.myDocument(for: provisioning)
			)
		)

		// TODO: Also add image url as attachment

		try await recordService.add(connection, to: wallet)

		return (request, connection)
	}

	func processResponse(
		_ message: ConnectionResponseMessage,
		with record: ConnectionRecord,
		in wallet: Wallet
	) async throws -> String {
		guard let handle = wallet as? IndyHandle else {
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
		record.tags[Tags.lastThreadId] = "message.threadId"
		if let endpoint = connection.document?.services?.first {
			record.endpoint = Endpoint(
				uri: endpoint.endpoint,
				did: nil,
				verkeys: endpoint.routingKeys
			)
		}

		try await recordService.update(record, in: wallet)

		return record.id
	}
}
