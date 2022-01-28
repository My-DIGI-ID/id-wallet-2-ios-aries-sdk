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
import XCTest

class ConnectionTests: XCTestCase {
	let fixture = Connection(
		did: "did",
		document: nil
	)

	func test_decode() throws {
		// Arrange
		let expected = fixture
		let json = try loadJson("Connection")

		// Act
		let actual: Connection = try JSONDecoder.shared.model(json)

		// Asert
		XCTAssertEqual(actual.did, expected.did)
		XCTAssertNil(actual.document)
	}

	func test_encode() throws {
		// Arrange
		let expected = try loadJson("Connection")

		// Act
		let actual = try JSONEncoder.shared.string(fixture)

		// Assert
		XCTAssertEqual(actual, expected)
	}
}
