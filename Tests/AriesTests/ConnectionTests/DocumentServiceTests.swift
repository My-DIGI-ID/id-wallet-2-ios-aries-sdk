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

class DocumentServiceTests: XCTestCase {
	let fixture = DocumentService(
		id: "id",
		recipientKeys: ["recipientKeys"],
		routingKeys: ["routingKeys"],
		endpoint: "endpoint"
	)

	func test_decode() throws {
		// Arrange
		let expected = fixture
		let json = try loadJson("DocumentService")

		// Act
		let actual: DocumentService = try JSONDecoder.shared.model(json)

		// Asert
		XCTAssertEqual(actual.id, expected.id)
		XCTAssertEqual(actual.recipientKeys, expected.recipientKeys)
		XCTAssertEqual(actual.routingKeys, expected.routingKeys)
		XCTAssertEqual(actual.endpoint, expected.endpoint)
	}

	func test_encode() throws {
		// Arrange
		let expected = try loadJson("DocumentService")

		// Act
		let actual = try JSONEncoder.shared.string(fixture)

		// Assert
		XCTAssertEqual(actual, expected)
	}
}
