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

final class WalletStorageConfigurationTests: XCTestCase {
    func test_encode() throws {
        // Arrange
        let config = WalletStorageConfiguration(
            path: "path",
            url: "url",
            scheme: "scheme",
            database: "database",
            tls: "tls"
        )
        let expected = try loadJson("WalletStorageConfiguration")

        // Act
        let actual = try JSONEncoder.shared.string(config)

        // Assert
        XCTAssertEqual(actual, expected)
    }

    func test_encode_full() throws {
        // Arrange
        let config = WalletStorageConfiguration(
            path: "path",
            url: "url",
            scheme: "scheme",
            database: "database",
            tls: "tls",
            maxConnections: 1,
            minIdleCount: 2,
            timeout: 3
        )
        let expected = try loadJson("WalletStorageConfigurationFull")

        // Act
        let actual = try JSONEncoder.shared.string(config)

        // Assert
        XCTAssertEqual(actual, expected)
    }
}
