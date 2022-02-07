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

/// A model containing information which describe the DID subject in some form.
public struct Document: Codable {
    private enum CodingKeys: String, CodingKey {
        case context = "@context"
        case id
        case controller
        case alsoKnownAs
        case verifications = "verificationMethod"
        case authentications = "authentication"
        case assertions = "assertionMethod"
        case agreements = "keyAgreement"
        case invocations = "capabilityInvocation"
        case delegations = "capabilityDelegation"
        case keys = "publicKey"
        case services = "service"
    }

    /// The links to the specifications.
    public let context: [String]?
	/// The DID of the subject this document is associated to.
	public let id: String
    /// The DIDs of the controllers.
    public var controller: [String]?
    /// The URIs of the other DIDs which refer to the same subject.
    public var alsoKnownAs: [String]?
	/// Methods to authenticate the subject or authorize interactions with it.
    public var verifications: [VerificationMethod]?
    /// Methods the subject is authenticated with.
    public var authentications: [VerificationMethod]?
    /// Methods to express claims.
    public var assertions: [VerificationMethod]?
    /// Methods to generate encryption material.
    public var agreements: [VerificationMethod]?
    /// Methods to invoke cryptographic capabilities.
    public var invocations: [VerificationMethod]?
    /// Methods to delegate cryptographic capabilities to another party.
    public var delegations: [VerificationMethod]?
	/// The public keys related to the subject used for verification.
	public var keys: [DocumentKey]?
	/// The exposed services for further communicate with the subject.
	public var services: [DocumentService]?

	init(id: String) {
        self.context = ["https://w3id.org/did/v1"]
		self.id = id
	}
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let context = try? container.decodeIfPresent(String.self, forKey: .context) {
            self.context = [context]
        } else {
            self.context = try container.decodeIfPresent([String].self, forKey: .context)
        }
        
        id = try container.decode(String.self, forKey: .id)
        
        if let controller = try? container.decodeIfPresent(String.self, forKey: .controller) {
            self.controller = [controller]
        } else {
            self.controller = try container.decodeIfPresent([String].self, forKey: .controller)
        }
            
        alsoKnownAs = try container.decodeIfPresent([String].self, forKey: .alsoKnownAs)
        verifications = try container.decodeIfPresent([VerificationMethod].self, forKey: .verifications)
        authentications = try container.decodeIfPresent([VerificationMethod].self, forKey: .authentications)
        assertions = try container.decodeIfPresent([VerificationMethod].self, forKey: .assertions)
        agreements = try container.decodeIfPresent([VerificationMethod].self, forKey: .agreements)
        invocations = try container.decodeIfPresent([VerificationMethod].self, forKey: .invocations)
        delegations = try container.decodeIfPresent([VerificationMethod].self, forKey: .delegations)
        keys = try container.decodeIfPresent([DocumentKey].self, forKey: .keys)
        services = try container.decodeIfPresent([DocumentService].self, forKey: .services)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let context = context {
            if context.count == 1 {
                try container.encode(context.first!, forKey: .context)
            } else {
                try container.encode(context, forKey: .context)
            }
        }
        
        try container.encode(id, forKey: .id)
        
        if let controller = controller {
            if controller.count == 1 {
                try container.encode(controller.first!, forKey: .controller)
            } else {
                try container.encode(controller, forKey: .controller)
            }
        }
        
        try container.encodeIfPresent(alsoKnownAs, forKey: .alsoKnownAs)
        try container.encodeIfPresent(verifications, forKey: .verifications)
        try container.encodeIfPresent(authentications, forKey: .authentications)
        try container.encodeIfPresent(assertions, forKey: .assertions)
        try container.encodeIfPresent(agreements, forKey: .agreements)
        try container.encodeIfPresent(invocations, forKey: .invocations)
        try container.encodeIfPresent(delegations, forKey: .delegations)
        try container.encodeIfPresent(keys, forKey: .keys)
        try container.encodeIfPresent(services, forKey: .services)
    }
}
