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

/// Message for proposing a proof.
public struct ProofProposalMessage: Message {
    private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case comment
        case preview = "presentation_proposal"
    }
    
    /// The identifier of the message.
    public let id: String
    /// The type of the message.
    public let type: String
    /// A comment for human readable presentation.
    public var comment: String?
    /// The preview of the proposed proof.
    public var preview: ProofPreview
    
    init(
        id: String = UUID().uuidString,
        preview: ProofPreview = ProofPreview()
    ) {
        self.id = id
        self.type = ""
        self.comment = nil
        self.preview = preview
    }
}
