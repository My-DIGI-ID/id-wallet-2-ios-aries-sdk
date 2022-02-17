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

public struct ThreadDecorator: Decorator {
    private enum CodingKeys: String, CodingKey {
        case threadId = "thid"
        case parentId = "pthid"
        case order = "sender_order"
        case receivedOrders = "received_orders"
        case goal = "goal_code"
    }
    
    public let threadId: String?
    public var parentId: String?
    public var order: Int?
    public var receivedOrders: [String: Int]?
    public var goal: String?
    
    init(threadId: String) {
        self.threadId = threadId
    }
}
