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

class ProvisioningServiceTests: XCTestCase {
	var walletData = DefaultWalletData(
		configuration: WalletConfiguration(id: UUID().uuidString),
		credentials: WalletCredentials(key: "test")
	)

    var wallet: IndyHandle!
	lazy var walletService = DefaultWalletService()
	lazy var recordService: RecordService = DefaultRecordService()
	lazy var service: ProvisioningService = DefaultProvisioningService(
		recordService: recordService
	)

	override open func setUp() async throws {
        try await super.setUp()
		try await walletService.create(for: walletData)
		wallet = try await walletService.get(for: walletData) as? IndyHandle
	}

	override open func tearDown() async throws {
		try await walletService.close(wallet!)
		try await walletService.delete(for: walletData)
		wallet = nil
        try await super.tearDown()
	}

	func test_get_record() async throws {
		// Arrange
		let owner = Owner(name: "Tester", imageUrl: nil)
		let expected = ProvisioningRecord(owner: owner)
		try await recordService.add(expected, to: wallet)

		// Act
		let actual = try await service.getRecord(from: wallet)

		// Assert
		XCTAssertEqual(actual.id, expected.id)
		XCTAssertEqual(actual.owner?.name, expected.owner?.name)
		XCTAssertEqual(actual.owner?.imageUrl, expected.owner?.imageUrl)
		XCTAssertEqual(actual.endpoint?.did, expected.endpoint?.did)
		XCTAssertEqual(actual.endpoint?.uri, expected.endpoint?.uri)
		XCTAssertEqual(actual.endpoint?.verkeys, expected.endpoint?.verkeys)
	}

	func test_get_same_record() async throws {
		// Arrange
		let owner = Owner(name: "Tester", imageUrl: nil)
		let record = ProvisioningRecord(owner: owner)
		try await recordService.add(record, to: wallet)

		// Act
		let first = try await service.getRecord(from: wallet)
		let second = try await service.getRecord(from: wallet)

		// Assert
		XCTAssertEqual(first.id, second.id)
		XCTAssertEqual(first.owner?.name, second.owner?.name)
		XCTAssertEqual(first.owner?.imageUrl, second.owner?.imageUrl)
		XCTAssertEqual(first.endpoint?.did, second.endpoint?.did)
		XCTAssertEqual(first.endpoint?.uri, second.endpoint?.uri)
		XCTAssertEqual(first.endpoint?.verkeys, second.endpoint?.verkeys)
	}
}
