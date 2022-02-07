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

public struct CredentialProposalMessage: Message {
    private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case comment
        case proposal = "credential_proposal"
        case schemaId = "schema_id"
        case schemaIssuer = "schema_issuer_did"
        case schemaName = "schema_name"
        case schemaVersion = "schema_version"
        case credentialId = "cred_def_id"
        case credentialIssuer = "issuer_did"
        case transport = "~transport"
    }
    
    /// Unique identifier of the message
    public let id: String
    /// Type of the message
    public let type: String
    /// Human readable text for judgement
    public var comment: String?
    /// Defines the requested information in the credential
    public var proposal: CredentialPreview?
    /// Filter for the DID of the issuer of the schema.
    public var schemaIssuer: String?
    /// Filter for the id of the schema itself.
    public var schemaId: String?
    /// Filter for the name of the schema.
    public var schemaName: String?
    /// Filter for the version of the schema.
    public var schemaVersion: String?
    /// Filter for the id of the credential definition
    public var credentialId: String?
    /// Filter for the DID of the issuer of the credential
    public var credentialIssuer: String?
    
    public var transport: TransportDecorator?
    
    public init(id: String = UUID().uuidString) {
        self.id = id
        self.type = "did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/issue-credential/1.0/propose-credential"
    }
}
