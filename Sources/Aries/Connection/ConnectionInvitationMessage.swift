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

/// Message for inviting another agent to a DID exchange.
public struct ConnectionInvitationMessage: Message {
    private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case label
        case imageUrl
        case endpoint = "serviceEndpoint"
        case routingKeys
        case recipientKeys
    }

    /// Then unique identifier
    public let id: String
    /// The type of message
	public let type: String
	/// The name of the of inviter.
	public let label: String?
	/// The profile picture of the inviter.
	public let imageUrl: String?
	/// The endpoint which can be used by the invitee for future responses.
	public let endpoint: String
	/// The keys used for secure routing.
	public let routingKeys: [String]?
	/// The keys of the recipients for verification.
	public let recipientKeys: [String]

	init(
		id: String = UUID().uuidString,
		label: String? = nil,
		imageUrl: String? = nil,
		endpoint: String,
		routingKeys: [String]? = nil,
		recipientKeys: [String]
	) {
        self.id = id
        self.type = "did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/connections/1.0/invitation"
		self.label = label
		self.imageUrl = imageUrl
		self.endpoint = endpoint
		self.routingKeys = routingKeys
		self.recipientKeys = recipientKeys
	}
}
