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

final class StringTests: XCTestCase {
    func test_short() {
        // Arrange
        let test = "abcd"
        let expected = "abcd$$$$"

        // Act
        let actual = test.clamp(to: 8, with: "$")

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_long() {
        // Arrange
        let test = "abcdefgh"
        let expected = "abcd"

        // Act
        let actual = test.clamp(to: 4, with: "$")

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_exact() {
        // Arrange
        let test = "abcdefgh"
        let expected = "abcdefgh"

        // Act
        let actual = test.clamp(to: 8, with: "$")

        // Assert
        XCTAssertEqual(actual, expected)
    }
}
