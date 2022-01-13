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

import Indy

/// This a ready-to-use implementation of the ``RecordService`` based on the wallet in Hyperledger Indy.
///
/// These functions directly pass through to the iOS wrapper and the underlying Indy implementation.
class DefaultRecordService: RecordService {
    func add<T: Record>(_ record: T, to wallet: Wallet) async throws {
        try await Indy.NonSecrets.addRecord(
            to: Int32(wallet.id),
            type: T.type,
            id: record.id,
            value: try JSONEncoder.shared.string(record),
            tags: try JSONEncoder.shared.string(record.tags)
        )
    }

    func get<T: Record>(_ type: T.Type, for id: String, from wallet: Wallet) async throws -> T {
        let itemEncoded = try await Indy.NonSecrets.getRecord(
            from: Int32(wallet.id),
            type: type.type,
            id: id,
            options: try JSONEncoder.shared.string(SearchOptions.default)
        )

        let item: SearchItem = try JSONDecoder.shared.model(itemEncoded)
        var record: T = try JSONDecoder.shared.model(item.value)
        record.tags = item.tags
        return record
    }

    func update<T: Record>(_ record: T, in wallet: Wallet) async throws {
        try await Indy.NonSecrets.updateRecordValue(
            in: Int32(wallet.id),
            type: type(of: record).type,
            id: record.id,
            value: try JSONEncoder.shared.string(record)
        )

        try await Indy.NonSecrets.updateRecordTags(
            in: Int32(wallet.id),
            type: type(of: record).type,
            id: record.id,
            tags: try JSONEncoder.shared.string(record.tags)
        )
    }

    func delete<T: Record>(_ type: T.Type, with id: String, in wallet: Wallet) async throws {
        let record = try await get(type, for: id, from: wallet)
        let keys = Array(record.tags.keys)
        let keysEncoded = try JSONEncoder.shared.string(keys)

        try await Indy.NonSecrets.deleteRecordTags(
            in: Int32(wallet.id), type: type.type, id: id, tags: keysEncoded
        )
        try await Indy.NonSecrets.deleteRecord(to: Int32(wallet.id), type: type.type, id: id)
    }

    func search<T: Record>(
        _: T.Type,
        in wallet: Wallet,
        with query: SearchQuery,
        count: Int?,
        skip: Int?
    ) async throws -> [T] {
        let queryEncoded = try JSONEncoder.shared.string(query)
        let optionsEncoded = try JSONEncoder.shared.string(SearchOptions.default)

        let handle = try await NonSecrets.search(
            in: Int32(wallet.id),
            type: T.type,
            query: queryEncoded,
            options: optionsEncoded
        )

        if let skip = skip, skip > 0 {
            _ = try await NonSecrets.continue(search: handle, in: Int32(wallet.id), count: skip)
        }

        var records = [SearchItem]()

        if let count = count {
            let resultEncoded = try await NonSecrets.continue(
                search: handle, in: Int32(wallet.id), count: count
            )

            let result: SearchResult = try JSONDecoder.shared.model(resultEncoded)

            if let resultRecords = result.records {
                records.append(contentsOf: resultRecords)
            }
        } else {
            while true {
                let resultEncoded = try await NonSecrets.continue(
                    search: handle, in: Int32(wallet.id), count: 100
                )

                let result: SearchResult = try JSONDecoder.shared.model(resultEncoded)

                if let resultRecords = result.records {
                    records.append(contentsOf: resultRecords)
                } else {
                    break
                }
            }
        }

        return try records.map {
            var record: T = try JSONDecoder.shared.model($0.value)
            record.tags = $0.tags
            return record
        }
    }
}
