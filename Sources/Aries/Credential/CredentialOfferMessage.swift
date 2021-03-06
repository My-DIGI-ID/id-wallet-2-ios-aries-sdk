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

/// Message for offering a credential to a potential holder.
public struct CredentialOfferMessage: Message {
    private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case comment
        case preview = "credential_preview"
        case offers = "offers~attach"
        case thread = "~thread"
    }
    
    /// Unique identifier of the message
    public let id: String
    /// Type of the message
    public let type: String
    /// Human readable text for judgement
    public var comment: String?
    /// Preview of the credential
    public var preview: CredentialPreview?
    /// The offered credentials
    public var offers: [AttachmentDecorator] = []
    /// Threading
    public var thread: ThreadDecorator?
    
    public init(id: String = UUID().uuidString) {
        self.id = id
        self.type = MessageType.credentialOffer.rawValue
    }
}
