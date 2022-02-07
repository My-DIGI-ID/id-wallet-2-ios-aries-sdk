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

/// Structure containing service information providing a way to
public struct DocumentService: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case priority
        case recipientKeys
        case routingKeys
        case accept
        case endpoint = "serviceEndpoint"
    }

	/// The unique URI of the service
	public let id: String
	/// The type of the service. Should be registered in the specification registries.
	public let type: String
    ///
    public var priority: Int?
	/// The public keys of the recipients.
	public var recipientKeys: [String]?
	/// The public keys of the routing points.
	public var routingKeys: [String]?
    /// 
    public var accept: [String]?
    /// The actual uri to send messages to.
    public var endpoint: String
    
	init(id: String, endpoint: String) {
		self.id = id
		self.type = "IndyAgent"
		self.endpoint = endpoint
	}
}
