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

// swiftlint:disable duplicate_imports

@testable import Aries
import protocol Aries.Wallet
import Indy
import XCTest

/// Test suite for the `CryptoService`.
/// Please refer to the documentation for custom implementations.
open class CryptoServiceTests: XCTestCase {

	let walletData: WalletData = DefaultWalletData(
		configuration: WalletConfiguration(id: UUID().uuidString),
		credentials: WalletCredentials(key: "123")
	)
	var wallet: Wallet!

	lazy var walletService: WalletService = DefaultWalletService()
	lazy var service: CryptoService = DefaultCryptoService()

	override open func setUp() async throws {
		try await walletService.create(for: walletData)
		wallet = try await walletService.get(for: walletData)
	}

	override open func tearDown() async throws {
		try await walletService.close(wallet!)
		try await walletService.delete(for: walletData)
	}

	func test_pack() async throws {
		// Arrange
		let expected = TestMessage(id: UUID().uuidString, type: "AF.TestMessage")
		let recipients = [Fixture.verkeyRandom]

		// Act & Assert
		// Should not crash, XCTAssertNoThrow uses autoclosure, which does not support async/await.
		_ = try await service.pack(expected, for: recipients, with: wallet!)
	}
}
