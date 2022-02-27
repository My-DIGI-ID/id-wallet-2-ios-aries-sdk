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

/// Structure for a single attribute of a credential
public struct CredentialAttribute: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case mimeType = "mime-type"
        case value
    }
    
    /// The key of the attribute
    public let name: String
    /// The type for the case of complex data
    public let mimeType: String?
    /// The value of the attribute
    public let value: String
    
    public init(
        name: String,
        value: String
    ) {
        self.name = name
        self.mimeType = nil
        self.value = value
    }
    
    /// Constructor for declaring other data than a simple key value pair.
    ///
    /// When defining an attribute of arbitrary form, we need to set a mime type and store the data as base64.
    public init(
        name: String,
        mimeType: String,
        valueBase64: String
    ) {
        self.name = name
        self.mimeType = mimeType
        self.value = valueBase64
    }
}
