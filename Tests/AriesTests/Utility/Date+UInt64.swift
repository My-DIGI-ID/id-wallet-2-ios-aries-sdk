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

extension Date {
    /// Convert to Unix timestamp in milliseconds represented as long
    func toUInt64() -> UInt64 {
        UInt64(timeIntervalSince1970 * 1000)
    }
}

extension UInt64 {
    /// Convert Unix timestamp in milliseconds to its Date representation
    func toDate() -> Date {
        Date(timeIntervalSince1970: Double(self) / 1000.0)
    }
}
