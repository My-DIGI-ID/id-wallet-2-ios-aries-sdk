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

class SignatureUtilTests: XCTestCase {
	let walletData = DefaultWalletData(
		configuration: WalletConfiguration(id: UUID().uuidString),
		credentials: WalletCredentials(key: "test")
	)
	let walletService = DefaultWalletService()
	var wallet: IndyHandle!

	override open func setUp() async throws {
		try await walletService.create(for: walletData)
		wallet = try await walletService.get(for: walletData) as? IndyHandle
	}

	override open func tearDown() async throws {
		try await walletService.close(wallet!)
		try await walletService.delete(for: walletData)
		wallet = nil
	}

	func test_sign_and_verify() async throws {
		// Arrange
		let key = try await Crypto.createKey(in: wallet)
		let expected = Connection(did: "1234")
		let encoded = try JSONEncoder.shared.encode(expected)

		// Act
		let decorator = try await SignatureUtil.sign(encoded, with: key, wallet)
		let result = try await SignatureUtil.verify(decorator)
		let actual = try JSONDecoder.shared.decode(Connection.self, from: result)

		// Assert
		XCTAssertEqual(actual.did, expected.did)
	}
}
