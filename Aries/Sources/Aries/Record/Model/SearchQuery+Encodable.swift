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

extension SearchQuery: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .none:
            try container.encode([String: String]())

        case let .and(expressions):
            if expressions.isEmpty {
                try container.encode([String: String]())
            } else {
                try container.encode(["$and": expressions])
            }

        case let .or(expressions):
            if expressions.isEmpty {
                try container.encode([String: String]())
            } else {
                try container.encode(["$or": expressions])
            }

        case let .not(expression):
            try container.encode(["$not": expression])

        case let .equal(name, value):
            try container.encode([name: value])

        case let .unequal(name, value):
            try container.encode([name: ["$neq": value]])

        case let .less(name, value):
            try container.encode([name: ["$lt": value]])

        case let .greater(name, value):
            try container.encode([name: ["$gt": value]])

        case let .greaterEqual(name, value):
            try container.encode([name: ["$gte": value]])

        case let .lessEqual(name, value):
            try container.encode([name: ["$lte": value]])

        case let .like(name, value):
            try container.encode([name: ["$like": value]])

        case let .in(name, values):
            try container.encode([name: ["$in": values]])
        }
    }
}
