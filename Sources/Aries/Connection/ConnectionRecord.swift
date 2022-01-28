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

/// The record holding different information about a connection and its current state.
public struct ConnectionRecord: Record {
	/// The type used for differentiation in the wallet.
	public static let type: String = "ConnectionRecord"
	/// The unique identifier in the wallet.
	public let id: String
	/// The DID of the library user (you) in this connection.
	public var myDid: String?
	/// The verkey of your DID in this connection.
	public var myVerkey: String?
	/// The DID of the connection partner.
	public var theirDid: String?
	/// The verkey of the partners DID in this connection.
	public var theirVerkey: String?
	/// Defines if multiple parties take part in this connection.
	public var multiParty: Bool = false
	/// The presentable alias of the partner.
	public var alias: ConnectionAlias?
	/// The endpoint of the partner for further communication.
	public var endpoint: Endpoint?
	/// The current state of the process of establishing the connection.
	public var state: ConnectionState = .invited
	/// General tags used for querying in the wallet.
	public var tags: [String: String] = [:]

	init(id: String = UUID().uuidString) {
		self.id = id
	}
}
