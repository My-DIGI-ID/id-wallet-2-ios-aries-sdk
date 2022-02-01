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

class ConnectionServiceTests: XCTestCase {
    lazy var walletService: WalletService = DefaultWalletService()
    lazy var recordService: RecordService = DefaultRecordService()
    lazy var provisioningService: ProvisioningService = DefaultProvisioningService(recordService: recordService)
	lazy var connectionService: ConnectionService = DefaultConnectionService(
		recordService: recordService,
		provisioningService: provisioningService
	)

	lazy var walletData0 = DefaultWalletData(
		configuration: WalletConfiguration(id: UUID().uuidString),
		credentials: WalletCredentials(key: "test")
	)
	lazy var walletData1 = DefaultWalletData(
		configuration: WalletConfiguration(id: UUID().uuidString),
		credentials: WalletCredentials(key: "test")
	)

	var wallet0: Wallet!
	var wallet1: Wallet!

	override open func setUp() async throws {
        try await super.setUp()
		try await walletService.create(for: walletData0)
		wallet0 = try await walletService.get(for: walletData0)

		try await walletService.create(for: walletData1)
		wallet1 = try await walletService.get(for: walletData1)
	}

	override open func tearDown() async throws {
        try await super.tearDown()
		try await walletService.close(wallet0)
		try await walletService.delete(for: walletData0)
		wallet0 = nil

		try await walletService.close(wallet1)
		try await walletService.delete(for: walletData1)
		wallet1 = nil
	}

	func test_flow() async throws {
		// Arrange
		let configuration = InvitationConfiguration()
		let owner = Owner(name: "Tester", imageUrl: nil)
		let endpoint = Endpoint(uri: "uri", did: "did", verkeys: ["verkey"])
		let provisioning = ProvisioningRecord(owner: owner, endpoint: endpoint)
		try await recordService.add(provisioning, to: wallet0)
		try await recordService.add(provisioning, to: wallet1)

		// Act
		let (invitation, recordInvitation) = try await connectionService
			.createInvitation(with: wallet0, configuration)

		let (request, recordRequest) = try await connectionService
			.createRequest(for: invitation, with: wallet1)

		let id0 = try await connectionService.processRequest(request, with: recordInvitation, in: wallet0)

		let (response, _) = try await connectionService
			.createResponse(for: id0, in: wallet0)

		let id1 = try await connectionService.processResponse(response, with: recordRequest, in: wallet1)

		// Assert
		let record0 = try await recordService.get(ConnectionRecord.self, for: id0, from: wallet0)
		let record1 = try await recordService.get(ConnectionRecord.self, for: id1, from: wallet1)

		XCTAssertEqual(record0.state, .connected)
		XCTAssertEqual(record1.state, .connected)
		XCTAssertEqual(record0.myDid, record1.theirDid)
		XCTAssertEqual(record0.theirDid, record1.myDid)
	}
}
