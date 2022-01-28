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
	public let controller: [String]?
	/// The actual public key.
	public let key: String

	init(
		id: String = UUID().uuidString,
		type: String,
		controller: [String]? = nil,
		key: String
	) {
		self.id = id
		self.type = type
		self.controller = controller
		self.key = key
	}
}
