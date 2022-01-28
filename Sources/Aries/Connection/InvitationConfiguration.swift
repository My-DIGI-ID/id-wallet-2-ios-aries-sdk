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

/// Configuration for establishing a new connection.
public struct InvitationConfiguration {
	/// The unique identifier of the new connection
	public let connectionId: String
	/// Your alternative alias in this connection
	public let myAlias: ConnectionAlias?
	/// The alternative alias for the connection partner.
	public let theirAlias: ConnectionAlias?
	/// Defines of multiple parties take part in this connection.
	public let multiParty: Bool
	/// Defines if the connection should be accepted without further intervention.
	public let autoAccept: Bool
	/// Defines if either the DID key or pure key format should be used.
	public let useDidKeyFormat: Bool
	/// General tags for the created connection record.
	public var tags: [String: String]

	public init(
		connectionId: String = UUID().uuidString,
		myAlias: ConnectionAlias? = nil,
		theirAlias: ConnectionAlias? = nil,
		multiParty: Bool = false,
		autoAccept: Bool = false,
		useDidKeyFormat: Bool = false,
		tags: [String: String] = [:]
	) {
		self.connectionId = connectionId
		self.myAlias = myAlias
		self.theirAlias = theirAlias
		self.multiParty = multiParty
		self.autoAccept = autoAccept
		self.useDidKeyFormat = useDidKeyFormat
		self.tags = tags
	}
}
