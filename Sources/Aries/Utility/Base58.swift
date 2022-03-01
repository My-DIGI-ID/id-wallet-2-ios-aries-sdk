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

enum Base58 {

	static func encode(_ input: Data) -> Data {
		var input = input

		// Skip zeros
		while input.first == .zero {
			input = input.advanced(by: 1)
		}

		return input
	}

	static func decode(_ input: Data) -> Data {

		return input
	}
}

extension Base58 {

	static func encode(_ input: Data) -> String? {
		let encoded: Data = encode(input)
		return String(data: encoded, encoding: .utf8)
	}

	static func decode(_ input: String) -> Data? {
        guard let encoded: Data = input.data(using: .utf8) else {
            return nil
        }
		return decode(encoded)
	}
}