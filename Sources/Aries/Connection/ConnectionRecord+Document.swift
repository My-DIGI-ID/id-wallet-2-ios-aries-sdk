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

/// Extension for generating DID documents for the participants of the connection.
extension ConnectionRecord {
	private static let defaultType = "Ed25519VerificationKey2018"

	// TODO: Replace this with mediator record.
	public func myDocument(for record: ProvisioningRecord) -> Document {
		Document(
			id: myDid ?? "",
			keys: [
				DocumentKey(
                    id: myDid.map { $0 + "#keys-1" } ?? "",
                    type: Self.defaultType,
                    controller: myDid.map { [$0] },
                    key: myVerkey ?? ""
				)
			],
			services: [
				DocumentService(
                    id: myDid.map { $0 + ";indy" } ?? "",
                    recipientKeys: myVerkey.map { [$0] } ?? [],
                    routingKeys: record.endpoint?.verkeys ?? [],
                    endpoint: record.endpoint?.uri ?? ""
				)
			]
		)
	}

	public func theirDocument() -> Document {
		Document(
			id: theirDid ?? "",
			keys: [
				DocumentKey(
                    id: theirDid.map { $0 + "#keys-1" } ?? "",
                    type: Self.defaultType,
                    controller: theirDid.map { [$0] },
                    key: theirVerkey ?? ""
				)
			],
			services: [
				DocumentService(
                    id: theirDid.map { $0 + ";indy" } ?? "",
                    recipientKeys: theirVerkey.map { [$0] } ?? [],
                    routingKeys: endpoint?.verkeys ?? [],
                    endpoint: endpoint?.uri ?? ""
				)
			]
		)
	}
}
