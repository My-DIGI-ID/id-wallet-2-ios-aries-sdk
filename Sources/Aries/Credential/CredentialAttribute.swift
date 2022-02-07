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

public struct CredentialAttribute: Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case mimeType = "mime-type"
        case value
    }
    
    public let name: String
    public let mimeType: String?
    public let value: String
    
    public init(
        name: String,
        value: String
    ) {
        self.name = name
        self.mimeType = nil
        self.value = value
    }
    
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
