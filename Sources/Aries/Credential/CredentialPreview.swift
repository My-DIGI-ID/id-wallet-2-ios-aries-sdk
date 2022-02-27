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

/// Container for all attributes of a potentially issued credential.
///
/// This is the actual data of a credential. It can and should be used for display.
public struct CredentialPreview: Codable {
    private enum CodingKeys: String, CodingKey {
        case type = "@type"
        case attributes
    }
 
    /// The type identifier of the preview.
    ///
    /// Although this is isn't a message in itself, it is a closed object in terms of the RFC and requires its own type.
    public let type: String
    /// The attributes of the credential.
    public var attributes: [CredentialAttribute] = []
    
    public init() {
        type = "did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/issue-credential/1.0/credential-preview"
    }
}
