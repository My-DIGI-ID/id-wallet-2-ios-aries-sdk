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

public struct MessageRequest<M: Message> {
    public let message: M
    public let recipientKeys: [String]
    public let senderKey: String?
    public let endpoint: String
    
    public init(
        message: M,
        recipientKeys: [String],
        senderKey: String? = nil,
        endpoint: String
    ) {
        self.message = message
        self.recipientKeys = recipientKeys
        self.senderKey = senderKey
        self.endpoint = endpoint
    }
}
