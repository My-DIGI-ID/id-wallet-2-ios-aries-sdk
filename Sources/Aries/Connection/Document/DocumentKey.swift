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

/// Structure containing key information of a DID to verify control.
public struct DocumentKey: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case controller
        case key = "publicKeyBase58"
    }

	/// The unique URI of the key.
	public let id: String
	/// The type of key.
	public let type: String
	/// The controller of this specific key enabled to represent the subject.
	public var controller: [String]?
	/// The actual public key.
	public var key: String

	init(
		id: String,
		type: String,
		controller: [String]? = nil,
		key: String
	) {
		self.id = id
		self.type = type
		self.controller = controller
		self.key = key
	}
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(String.self, forKey: .type)
        
        if let controller = try? container.decodeIfPresent(String.self, forKey: .controller) {
            self.controller = [controller]
        } else {
            self.controller = try container.decodeIfPresent([String].self, forKey: .controller)
        }
        
        key = try container.decode(String.self, forKey: .key)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        
        if let controller = controller {
            if controller.count == 1 {
                try container.encode(controller.first!, forKey: .controller)
            } else {
                try container.encode(controller, forKey: .controller)
            }
        }
        
        try container.encode(key, forKey: .key)
    }
}
