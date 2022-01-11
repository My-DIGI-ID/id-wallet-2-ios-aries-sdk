/*
 * Copyright 2021 Bundesrepublik Deutschland
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */

extension SearchOptions: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(records, forKey: .records)
        try container.encode(count, forKey: .count)
        try container.encode(type, forKey: .type)
        try container.encode(value, forKey: .value)
        try container.encode(tags, forKey: .tags)
    }

    private enum CodingKeys: String, CodingKey {
        case records = "retrieveRecords"
        case count = "retrieveTotalCount"
        case type = "retrieveType"
        case value = "retrieveValue"
        case tags = "retrieveTags"
    }
}
