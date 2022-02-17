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

/// Message requesting DID exchange in response to an invitation.
public struct ConnectionRequestMessage: Message {
    private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case label
        case imageUrl
        case connection
        case transport = "~transport"
    }

    /// The unique identifier
    public let id: String
    /// The type of message
    public let type: String
	/// Name of the invitee.
	public let label: String?
	/// URL of profile image of the invitee.
	public let imageUrl: String?
	/// Container for the DID and corresponding document of the invitee.
	public let connection: Connection
    /// Decorator for the response mode
    public var transport: TransportDecorator?

	init(
		id: String = UUID().uuidString,
		label: String? = nil,
		imageUrl: String? = nil,
		connection: Connection
	) {
        self.id = id
        self.type = MessageType.connectionRequest.rawValue
        self.label = label
        self.imageUrl = imageUrl
        self.connection = connection
	}
}
