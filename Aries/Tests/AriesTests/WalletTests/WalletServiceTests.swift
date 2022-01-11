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

/// The tests for the wallet service are black box tests and implementation agnostic
/// By defining them as open, we can create inheriting test cases for other
/// implementations without the need to adapt the tests
open class WalletServiceTests: XCTestCase {
    let walletService: WalletService = DefaultWalletService()

    func test_generate_key() async throws {
        // Act
        let result = try await walletService.generateKey(with: nil)

        // Assert
        XCTAssertFalse(result.isEmpty, "Generated wallet master key should not be empty")
    }

    func test_generate_key_with_seed() async throws {
        // Arrange
        let seed = "Hyperledger Aries"

        // Act
        let result = try await walletService.generateKey(with: seed)

        // Assert
        XCTAssertFalse(result.isEmpty, "Generated wallet master key should not be empty")
    }

    func test_all_operations() async throws {
        try await test(with: nil)
    }

    func test_all_operations_with_raw() async throws {
        try await test(with: .raw)
    }

    private func test(with method: KeyDerivationMethod?) async throws {
        let config = WalletConfiguration(id: UUID().uuidString)
        let creds = WalletCredentials(
            key: method == .raw ? try await walletService.generateKey(with: nil) : "1",
            derivationMethodKey: method
        )

        try await walletService.create(for: config, creds)

        let wallet = try await walletService.get(for: config, creds)

        assert(wallet.id != 0)

        try await walletService.close(wallet)

        try await walletService.delete(for: config, creds)

        do {
            _ = try await walletService.get(for: config, creds)
            XCTFail("Expected to throw while getting deleted wallet")
        } catch {}
    }
}
