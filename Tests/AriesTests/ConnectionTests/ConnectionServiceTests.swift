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
import IndyObjc
import XCTest

class ConnectionServiceTests: XCTestCase {
    lazy var walletService: WalletService = DefaultWalletService()
    lazy var recordService: RecordService = DefaultRecordService()
    lazy var messageService: MessageService = DefaultMessageService()
    lazy var ledgerService: LedgerService = DefaultLedgerService()
    lazy var poolService: PoolService = DefaultPoolService()
    
    lazy var provisioningService: ProvisioningService = DefaultProvisioningService(recordService: recordService)
	lazy var connectionService: ConnectionService = DefaultConnectionService(
		recordService: recordService,
		provisioningService: provisioningService
	)
    lazy var credentialService: CredentialService = DefaultCredentialService(
        recordService: recordService,
        provisioningService: provisioningService,
        ledgerService: ledgerService
    )
    
	lazy var walletData0 = DefaultWalletData(
		configuration: WalletConfiguration(id: UUID().uuidString),
		credentials: WalletCredentials(key: "test")
	)
	lazy var walletData1 = DefaultWalletData(
		configuration: WalletConfiguration(id: UUID().uuidString),
		credentials: WalletCredentials(key: "test")
	)
    
    lazy var poolName = "Pool"
    lazy var poolGenenis = Bundle.module.path(forResource: "idw_eesditest", ofType: "", inDirectory: "Resource")!

	var context0: Context!
	var context1: Context!

	override open func setUp() async throws {
        try await super.setUp()
		try await walletService.create(for: walletData0)
        try await walletService.create(for: walletData1)
        
        try? await poolService.delete(for: poolName)
        try await poolService.create(with: poolName, poolGenenis)
        
        let pool = try await poolService.get(for: poolName)
        
        context0 = Context(
            wallet: try await walletService.get(for: walletData0),
            pool: pool
        )
        
        context1 = Context(
            wallet: try await walletService.get(for: walletData1),
            pool: pool
        )
	}

	override open func tearDown() async throws {
        try await super.tearDown()

        try await poolService.close(context0.pool)
        try await poolService.delete(for: poolName)
        
        try await walletService.close(context0.wallet)
		try await walletService.delete(for: walletData0)
		context0 = nil

        try await walletService.close(context1.wallet)
		try await walletService.delete(for: walletData1)
		context1 = nil
	}

	func test_flow() async throws {
		// Arrange
		let configuration = InvitationConfiguration()
		let owner = Owner(name: "Tester", imageUrl: nil)
		let endpoint = Endpoint(uri: "uri", did: "did", verkeys: ["verkey"])
		let provisioning = ProvisioningRecord(owner: owner, endpoint: endpoint)
        try await recordService.add(provisioning, to: context0.wallet)
        try await recordService.add(provisioning, to: context1.wallet)

		// Act
		let (invitation, recordInvitation) = try await connectionService
            .createInvitation(for: configuration, with: context0)

		let (request, recordRequest) = try await connectionService
            .createRequest(for: invitation, with: context1)

        let id0 = try await connectionService.processRequest(request, with: recordInvitation, context0)

		let (response, _) = try await connectionService
            .createResponse(for: id0, with: context0)

        let id1 = try await connectionService.processResponse(response, with: recordRequest, context1)

		// Assert
        let record0 = try await recordService.get(ConnectionRecord.self, for: id0, from: context0.wallet)
        let record1 = try await recordService.get(ConnectionRecord.self, for: id1, from: context1.wallet)

		XCTAssertEqual(record0.state, .connected)
		XCTAssertEqual(record1.state, .connected)
		XCTAssertEqual(record0.myDid, record1.theirDid)
		XCTAssertEqual(record0.theirDid, record1.myDid)
	}
}
