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

public struct AckMessage: Message {
    public enum Status: String, Codable {
        case ok = "OK"
        case fail = "FAIL"
        case pending = "PENDING"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case status
        case thread = "~thread"
    }
    
    public let id: String
    public let type: String
    public var status: Status
    public var thread: ThreadDecorator?
    
    init(
        id: String = UUID().uuidString,
        type: String = MessageType.ack.rawValue,
        status: AckStatus = .ok
    ) {
        self.id = id
        self.type = type
        self.status = status
    }
}
