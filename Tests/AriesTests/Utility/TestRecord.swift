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

@testable import Aries
import Foundation

struct TestRecord: Record {
    static let type: String = "AF.TestRecord"
    let id: String
    var created: Date
    var updated: Date?
    var tags: [String: String]

    init(
        id: String = UUID().uuidString,
        created: Date = Date(),
        updated: Date? = nil,
        tags: [String: String] = [:]
    ) {
        self.id = id
        self.created = created
        self.updated = updated
        self.tags = tags
    }
}

extension TestRecord: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let createdTS = try container.decode(UInt64.self, forKey: .created)
        let updatedTS = try container.decodeIfPresent(UInt64.self, forKey: .updated)
        id = try container.decode(String.self, forKey: .id)
        created = createdTS.toDate()
        updated = updatedTS?.toDate()
        tags = [:]
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(created.toUInt64(), forKey: .created)
        try container.encodeIfPresent(updated?.toUInt64(), forKey: .updated)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case created
        case updated
    }
}
