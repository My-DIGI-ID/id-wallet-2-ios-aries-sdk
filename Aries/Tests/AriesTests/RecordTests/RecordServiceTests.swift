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

/// The tests for the record service are black box tests and implementation agnostic
/// By defining them as open, we can create inheriting test cases for other
/// implementations without the need to adapt the tests
open class RecordServiceTests: XCTestCase {
    let config = WalletConfiguration(id: UUID().uuidString)
    let creds = WalletCredentials(key: "test")
    let walletService: WalletService = DefaultWalletService()
    var wallet: Wallet!

    let recordService: RecordService = DefaultRecordService()

    override open func setUp() async throws {
        try await walletService.create(for: config, creds)
        wallet = try await walletService.get(for: config, creds)
    }

    override open func tearDown() async throws {
        try await walletService.close(wallet!)
        try await walletService.delete(for: config, creds)
        wallet = nil
    }

    func test_store_and_retrieve_record_with_tags() async throws {
        // Arrange
        let tagName = UUID().uuidString
        let tagValue = UUID().uuidString
        let record = TestRecord(tags: [tagName: tagValue])

        // Act
        try await recordService.add(record, to: wallet)
        let retrieved = try await recordService.get(TestRecord.self, for: record.id, from: wallet)

        // Assert
        XCTAssertEqual(record.id, retrieved.id)
        XCTAssertEqual(record.tags[tagName], record.tags[tagName], tagValue)
    }

    func test_store_and_retrieve_record_with_tags_using_search() async throws {
        // Arrange
        let tagName = UUID().uuidString
        let tagValue = UUID().uuidString
        let record = TestRecord(tags: [tagName: tagValue])

        // Act
        try await recordService.add(record, to: wallet)
        let search = try await recordService.search(
            TestRecord.self,
            in: wallet,
            with: .equal(name: tagName, value: tagValue),
            count: 100,
            skip: 0
        )

        // Assert
        let first = search.first
        XCTAssertNotNil(first)
        XCTAssertEqual(first?.id, record.id)
        XCTAssertEqual(first?.tags[tagName], tagValue)
    }

    func test_update_record_with_tags() async throws {
        // Arrange
        let tagName = UUID().uuidString
        let tagValue = UUID().uuidString
        let tagValueNew = UUID().uuidString
        let record = TestRecord(tags: [tagName: tagValue])

        // Act
        try await recordService.add(record, to: wallet)

        var retrieved = try await recordService.get(TestRecord.self, for: record.id, from: wallet)
        retrieved.tags[tagName] = tagValueNew

        try await recordService.update(retrieved, in: wallet)

        let updated = try await recordService.get(TestRecord.self, for: record.id, from: wallet)

        // Assert
        XCTAssertEqual(record.id, updated.id)
        XCTAssertEqual(updated.tags[tagName], tagValueNew)
        XCTAssertNotEqual(record.tags[tagName], updated.tags[tagName])
    }

    func test_retrieve_non_existent_record() async throws {
        do {
            _ = try await recordService.get(TestRecord.self, for: UUID().uuidString, from: wallet)
            XCTFail("Should not find any record for a random UUID in an empty wallet")
        } catch {}
    }

    func test_retrieve_non_existent_record_with_search() async throws {
        // Act
        let result = try await recordService.search(
            TestRecord.self,
            in: wallet,
            with: .none,
            count: 100,
            skip: 0
        )

        // Assert
        XCTAssert(result.isEmpty)
    }

    func test_filter_by_created_at() async throws {
        var recordFirst = TestRecord()
        recordFirst.tags["~created"] = "\(recordFirst.created.toUInt64())"
        print(recordFirst)
        try await recordService.add(recordFirst, to: wallet)

        try await Task.sleep(nanoseconds: 1_000_000)
        let now = "\(Date().toUInt64())"
        print(now)
        try await Task.sleep(nanoseconds: 1_000_000)

        var recordSecond = TestRecord()
        recordSecond.tags["~created"] = "\(recordSecond.created.toUInt64())"
        print(recordSecond)
        try await recordService.add(recordSecond, to: wallet)

        let result = try await recordService.search(
            TestRecord.self,
            in: wallet,
            with: .greater(name: "~created", value: now),
            count: 100,
            skip: 0
        )

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, recordSecond.id)
    }
}
