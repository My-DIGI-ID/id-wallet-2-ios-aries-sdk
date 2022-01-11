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

@testable import Aries
import XCTest

final class SearchQueryTests: XCTestCase {
    func test_encode_and_empty() throws {
        // Arrange
        let options = SearchQuery.and([])
        let expected = try loadJson("SearchQueryEmpty")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_or_empty() throws {
        // Arrange
        let options = SearchQuery.or([])
        let expected = try loadJson("SearchQueryEmpty")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_not() throws {
        // Arrange
        let options = SearchQuery.not(.none)
        let expected = try loadJson("SearchQueryNot")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_equal() throws {
        // Arrange
        let options = SearchQuery.equal(name: "name", value: "value")
        let expected = try loadJson("SearchQueryEqual")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_unequal() throws {
        // Arrange
        let options = SearchQuery.unequal(name: "name", value: "value")
        let expected = try loadJson("SearchQueryUnequal")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_greater() throws {
        // Arrange
        let options = SearchQuery.greater(name: "name", value: "value")
        let expected = try loadJson("SearchQueryGreater")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_greater_equal() throws {
        // Arrange
        let options = SearchQuery.greaterEqual(name: "name", value: "value")
        let expected = try loadJson("SearchQueryGreaterEqual")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_less() throws {
        // Arrange
        let options = SearchQuery.less(name: "name", value: "value")
        let expected = try loadJson("SearchQueryLess")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_less_equal() throws {
        // Arrange
        let options = SearchQuery.lessEqual(name: "name", value: "value")
        let expected = try loadJson("SearchQueryLessEqual")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_like() throws {
        // Arrange
        let options = SearchQuery.like(name: "name", value: "value")
        let expected = try loadJson("SearchQueryLike")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_in_empty() throws {
        // Arrange
        let options = SearchQuery.in(name: "name", value: [])
        let expected = try loadJson("SearchQueryInEmpty")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_in_single() throws {
        // Arrange
        let options = SearchQuery.in(name: "name", value: ["value"])
        let expected = try loadJson("SearchQueryInSingle")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_in_multiple() throws {
        // Arrange
        let options = SearchQuery.in(name: "name", value: ["value", "value"])
        let expected = try loadJson("SearchQueryInMultiple")

        // Act
        let actual = try JSONEncoder.shared.string(options)

        // Assert
        XCTAssertEqual(actual, expected)
    }
}
