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
    lazy var poolName = "Pool"
    lazy var poolGenenis = Bundle.module.path(forResource: "idw_eesditest", ofType: "", inDirectory: "Resource")!
	lazy var walletData = DefaultWalletData(
		configuration: WalletConfiguration(id: UUID().uuidString),
		credentials: WalletCredentials(key: "test")
	)
    
	lazy var walletService = DefaultWalletService()
	lazy var recordService: RecordService = DefaultRecordService()
    lazy var poolService: PoolService = DefaultPoolService()
	lazy var service: ProvisioningService = DefaultProvisioningService(
		recordService: recordService
	)
    
    var context: Context!

	override open func setUp() async throws {
        try await super.setUp()
        try await walletService.create(for: walletData)
        
        try? await poolService.delete(for: poolName)
        try await poolService.create(with: poolName, poolGenenis)
        
        context = Context(
            wallet: try await walletService.get(for: walletData),
            pool: try await poolService.get(for: poolName)
        )
	}

	override open func tearDown() async throws {
        try await poolService.close(context.pool)
        try await poolService.delete(for: poolName)
        
        try await walletService.close(context.wallet)
        try await walletService.delete(for: walletData)
        
        context = nil
        
        try await super.tearDown()
	}

	func test_get_record() async throws {
		// Arrange
		let owner = Owner(name: "Tester", imageUrl: nil)
		let expected = ProvisioningRecord(owner: owner)
        try await recordService.add(expected, to: context.wallet)

		// Act
        let actual = try await service.getRecord(with: context)

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
        try await recordService.add(record, to: context.wallet)

		// Act
		let first = try await service.getRecord(with: context)
		let second = try await service.getRecord(with: context)

		// Assert
		XCTAssertEqual(first.id, second.id)
		XCTAssertEqual(first.owner?.name, second.owner?.name)
		XCTAssertEqual(first.owner?.imageUrl, second.owner?.imageUrl)
		XCTAssertEqual(first.endpoint?.did, second.endpoint?.did)
		XCTAssertEqual(first.endpoint?.uri, second.endpoint?.uri)
		XCTAssertEqual(first.endpoint?.verkeys, second.endpoint?.verkeys)
	}
    
    func test_update_master_secret_id() async throws {
        // Arrange
        let secret = "ABC"
        let before = try await service.getRecord(with: context)
        
        // Act
        try await service.update(secret, with: context)
        let after = try await service.getRecord(with: context)
        
        // Assert
        XCTAssertEqual(before.id, after.id)
        XCTAssertNotEqual(before.masterSecretId, after.masterSecretId)
        XCTAssertEqual(after.masterSecretId, secret)
    }
    
    func test_update_master_secret_id_with_existing() async throws {
        // Arrange
        let secret0 = "ABC"
        let secret1 = "DEF"
        try await service.update(secret0, with: context)
        let before = try await service.getRecord(with: context)
        
        // Act
        try await service.update(secret1, with: context)
        let after = try await service.getRecord(with: context)
        
        // Assert
        XCTAssertEqual(before.id, after.id)
        XCTAssertNotEqual(before.masterSecretId, after.masterSecretId)
        XCTAssertEqual(after.masterSecretId, secret1)
    }
}
