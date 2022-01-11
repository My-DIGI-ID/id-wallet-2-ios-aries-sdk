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

struct SearchOptions {
    let records: Bool
    let count: Bool
    let type: Bool
    let value: Bool
    let tags: Bool
}

extension SearchOptions {
    static let `default` = SearchOptions(
        records: true,
        count: false,
        type: false,
        value: true,
        tags: true
    )
}
