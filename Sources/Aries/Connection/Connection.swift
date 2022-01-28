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

/// Container representing a DID with all its documented information.
public struct Connection: Codable {
    private enum CodingKeys: String, CodingKey {
        case did = "DID"
        case document = "DIDDoc"
    }

    /// The DID of the connection partner.
	public let did: String
	/// The DID document representing all available information about the subject.
	public let document: Document?

	init(
		did: String,
		document: Document? = nil
	) {
		self.did = did
		self.document = document
	}
}
