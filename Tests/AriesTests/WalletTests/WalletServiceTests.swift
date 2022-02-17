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
import Indy
import IndyObjc
import XCTest

class WalletServiceTests: XCTestCase {
	var walletService = DefaultWalletService()

    func test_generate_key() async throws {
        // Act
        let result = try await DefaultWalletService.generateKey()

        // Assert
        XCTAssertFalse(result.isEmpty, "Generated wallet master key should not be empty")
    }

    func test_generate_key_with_seed() async throws {
        // Arrange
        let seed = "+/=Hyperledger Aries"

        // Act
        let result = try await DefaultWalletService.generateKey(with: seed)

        // Assert
        XCTAssertFalse(result.isEmpty, "Generated wallet master key should not be empty")
    }

    func test_all_operations() async throws {
        try await test(with: nil, "1")
    }

    func test_all_operations_with_raw() async throws {
        try await test(with: .raw, try await DefaultWalletService.generateKey())
    }
    
    func test_all_operations_with_raw_no_base58() async throws {
        try await test(with: .raw, "9AdhysU")
    }

    private func test(with method: KeyDerivationMethod?, _ key: String) async throws {
		let config = WalletConfiguration(id: UUID().uuidString)
        let creds = WalletCredentials(
            key: key,
            derivationMethodKey: method
        )

		let data = DefaultWalletData(configuration: config, credentials: creds)

        try await walletService.create(for: data)

        let wallet = try await walletService.get(for: data) as? IndyHandle

		XCTAssertNotNil(wallet)

        assert(wallet != 0)

        try await walletService.close(wallet!)

        try await walletService.delete(for: data)

        do {
            _ = try await walletService.get(for: data)
            XCTFail("Expected to throw while getting deleted wallet")
        } catch {}
    }
}
