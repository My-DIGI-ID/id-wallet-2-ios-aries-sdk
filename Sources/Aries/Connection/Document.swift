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
        case id
        case controller
        case alsoKnownAs
        case context = "@context"
        case keys = "publicKey"
        case services = "service"
    }

	/// The DID of the subject this document is associated to.
	public let id: String
	/// The DIDs of the controllers.
	public let controller: [String]?
	/// The URIs of the other DIDs which refer to the same subject.
	public let alsoKnownAs: [String]?
	/// The links to the specifications.
	public let context: [String]
	/// The public keys related to the subject used for verification.
	public let keys: [DocumentKey]?
	/// The exposed services for further communicate with the subject.
	public let services: [DocumentService]?

	init(
		id: String,
		controller: [String]? = nil,
		alsoKnownAs: [String]? = nil,
		keys: [DocumentKey]? = nil,
		services: [DocumentService]? = nil
	) {
		self.id = id
		self.controller = controller
		self.alsoKnownAs = alsoKnownAs
		self.context = ["https://w3id.org/did/v1"]
		self.keys = keys
		self.services = services
	}
}
