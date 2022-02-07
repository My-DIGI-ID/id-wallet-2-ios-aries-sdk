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

public struct AttachmentDecorator: Decorator {
    private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case mimeType = "mime-type"
        case data
    }
    
    private static let keyBase64 = "base64"
    private static let keySha256 = "sha256"
    
    public let id: String
    public let mimeType: String
    var data: [String: String] = [:]
    
    public var base64: String? {
        get { return data[Self.keyBase64] }
        set { data[Self.keyBase64] = newValue }
    }
    
    public var sha256: String? {
        get { return data[Self.keySha256] }
        set { data[Self.keySha256] = newValue }
    }
    
    public init(
        id: String = UUID().uuidString,
        mimeType: String,
        base64: String? = nil,
        sha256: String? = nil
    ) {
        self.id = id
        self.mimeType = mimeType
        
        if let base64 = base64 {
            self.base64 = base64
        }
        
        if let sha256 = sha256 {
            self.sha256 = sha256
        }
    }
}
