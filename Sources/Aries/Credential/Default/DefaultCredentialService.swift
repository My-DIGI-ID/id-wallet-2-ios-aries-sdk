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

import Foundation
import Indy
import IndyObjc

class DefaultCredentialService: CredentialService {
    
    private let recordService: RecordService
    private let provisioningService: ProvisioningService
    private let ledgerService: LedgerService
    
    init(
        recordService: RecordService,
        provisioningService: ProvisioningService,
        ledgerService: LedgerService
    ) {
        self.recordService = recordService
        self.provisioningService = provisioningService
        self.ledgerService = ledgerService
    }
    
    func proposal() async throws -> CredentialProposalMessage {
        var message = CredentialProposalMessage()
        message.transport = TransportDecorator(mode: .all)
        return message
    }
    
    func process(
        _ message: CredentialOfferMessage,
        for connectionId: String,
        with context: Context
    ) async throws -> String {
        guard let attachment = message.offers.first(where: { $0.id == "libindy-cred-offer-0" }) else {
            throw AriesError.notFound("Credential Offer")
        }
        
        let decoded = Data(base64Encoded: attachment.base64!)!
        let offer = String(data: decoded, encoding: .utf8)!
        
        guard
            let structure = try JSONSerialization.jsonObject(with: decoded) as? [String: Any],
            let definition = structure["cred_def_id"] as? String,
            let schema = structure["schema_id"] as? String else {
                throw AriesError.invalidType("Credential offer")
            }
        
        var record = CredentialRecord()
        record.offer = offer
        record.definition = definition
        record.schema = schema
        record.attributes = message.preview?.attributes ?? []
        record.state = .offered
        record.connection = connectionId
        record.tags[Tags.connectionKey] = connectionId
        record.tags[Tags.lastThreadId] = message.thread?.threadId ?? message.id
                
        try await recordService.add(record, to: context.wallet)
        
        return record.id
    }
    
    func request(
        for credentialId: String,
        with context: Context
    ) async throws -> CredentialRequestMessage {
        guard let handle = context.wallet as? IndyHandle else {
            throw AriesError.invalidType("Wallet")
        }
        
        var record = try await recordService.get(CredentialRecord.self, for: credentialId, from: context.wallet)
        let provisioning = try await provisioningService.getRecord(with: context)
        let did: String
        
        guard let connectionId = record.connection else {
            throw AriesError.notFound("Connection ID")
        }
        
        let connection = try await recordService.get(ConnectionRecord.self, for: connectionId, from: context.wallet)
        
        guard let did = connection.myDid else {
            throw AriesError.notFound("My DID")
        }

        let (_, definition) = try await ledgerService.credential(for: record.definition!, with: context)
        
        let (request, metadata) = try await AnonCreds.Prover.request(
            from: record.offer!,
            definition,
            did,
            provisioning.masterSecretId!,
            handle
        )
        
        record.metadata = metadata
        try await recordService.update(record, in: context.wallet)
        
        // Message
        let attachment = AttachmentDecorator(
            id: "libindy-cred-request-0",
            mimeType: "application/json",
            base64: request.data(using: .utf8)!.base64EncodedString()
        )
                
        var message = CredentialRequestMessage()
        message.requests.append(attachment)
        message.thread = ThreadDecorator(threadId: record.tags[Tags.lastThreadId]!)
        message.transport = TransportDecorator(mode: .all)
        
        return message
    }
    
    func process(_ message: CredentialIssueMessage, with context: Context) async throws -> String {
        guard let handle = context.wallet as? IndyHandle else {
            throw AriesError.invalidType("Wallet")
        }
        
        guard let attachment = message.credentials.first(where: { $0.id == "libindy-cred-0" }) else {
            throw AriesError.notFound("Credential")
        }
        
        let credentialEncoded = Data(base64Encoded: attachment.base64!)!
        let credentialJson = String(data: credentialEncoded, encoding: .utf8)!
        
        guard
            let structure = try JSONSerialization.jsonObject(with: credentialEncoded) as? [String: Any],
            let credentialDefinitionId = structure["cred_def_id"] as? String,
            let revocationDefinitionId = structure["rev_reg_id"] as? String else {
                throw AriesError.invalidType("Credential issue")
            }
        
        let credentialDefinition = try await ledgerService.credential(for: credentialDefinitionId, with: context).1
        let revocationDefinition = try await ledgerService.registry(for: revocationDefinitionId, with: context).1
        
        var record = try await recordService.search(
            CredentialRecord.self,
            in: context.wallet,
            with: .equal(name: Tags.lastThreadId, value: message.thread!.threadId!),
            count: 1,
            skip: 0
        ).first!
                
        let credentialId = try await Indy.AnonCreds.Prover.store(
            credentialJson,
            for: record.id,
            record.metadata!,
            credentialDefinition,
            revocationDefinition,
            handle
        )
        
        record.credential = credentialId
        record.revocation = revocationDefinitionId
        
        try await recordService.update(record, in: context.wallet)
        
        return record.id
    }
}
