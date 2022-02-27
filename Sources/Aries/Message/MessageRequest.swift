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

/// The container for a sendable message.
public struct MessageRequest<M: Message> {
    /// The message to be sent.
    public let message: M
    /// The verkey of the recipients of this message.
    public let recipientKeys: [String]
    /// The verkey of the sending agent.
    public let senderKey: String?
    /// Additional headers for the transport level request.
    public let headers: [String: String]
    /// The actual endpoint the message should be sent to
    public let endpoint: String
    
    public init(
        message: M,
        recipientKeys: [String],
        senderKey: String? = nil,
        headers: [String: String] = [:],
        endpoint: String
    ) {
        self.message = message
        self.recipientKeys = recipientKeys
        self.senderKey = senderKey
        self.headers = headers
        self.endpoint = endpoint
    }
}
