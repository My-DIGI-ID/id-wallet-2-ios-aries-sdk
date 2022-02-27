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

import Foundation
import Indy
import IndyObjc

/// This a ready-to-use implementation of the ``RecordService`` based on the wallet in Hyperledger Indy.
///
/// These functions directly pass through to the iOS wrapper and the underlying Indy implementation.
public class DefaultRecordService: RecordService {
    public func add<T: Record>(_ record: T, with context: Context) async throws {
        guard let wallet = context.wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

        try await NonSecrets.addRecord(
            to: wallet,
            type: T.type,
            id: record.id,
            value: try JSONEncoder.shared.string(record),
            tags: record.tags
        )
    }

    public func get<T: Record>(_: T.Type, for id: String, with context: Context) async throws -> T {
        guard let wallet = context.wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

		let options = SearchOptions(
			records: false, count: false, type: true, value: true, tags: true)

        let item = try await NonSecrets.getRecord(
            from: wallet,
            type: T.type,
            id: id,
            options: options
        )

		var record: T = try JSONDecoder.shared.model(item.value!)
		record.tags = item.tags!
		return record
    }

    public func update<T: Record>(_ record: T, with context: Context) async throws {
        guard let wallet = context.wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

        try await NonSecrets.updateRecordValue(
            in: wallet,
            type: T.type,
            id: record.id,
            value: try JSONEncoder.shared.string(record)
        )

        try await NonSecrets.updateRecordTags(
            in: wallet,
            type: T.type,
            id: record.id,
            tags: record.tags
        )
    }

    public func delete<T: Record>(_: T.Type, for id: String, with context: Context) async throws {
        guard let wallet = context.wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

		let options = SearchOptions(
			records: false, count: false, type: false, value: false, tags: true)
		let item = try await NonSecrets.getRecord(
			from: wallet,
			type: T.type,
			id: id,
			options: options
		)
		let keys: [String] = item.tags == nil ? [] : Array(item.tags!.keys)

        try await NonSecrets.deleteRecordTags(
            in: wallet, type: T.type, id: id, tags: keys
        )
        try await NonSecrets.deleteRecord(to: wallet, type: T.type, id: id)
    }

    public func search<T: Record>(
        _: T.Type,
        with context: Context,
        matching query: SearchQuery,
        count: Int?,
        skip: Int?
    ) async throws -> [T] {
        guard let wallet = context.wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

		let options = SearchOptions(
			records: true, count: false, type: false, value: true, tags: true)

        let handle = try await NonSecrets.search(
            in: wallet,
            type: T.type,
            query: query,
            options: options
        )

        if let skip = skip, skip > 0 {
            _ = try await NonSecrets.continue(search: handle, in: wallet, count: skip)
        }

        var items = [SearchItem]()

        if let count = count {
			if let result = try await NonSecrets
				.continue(search: handle, in: wallet, count: count).records {
				items.append(contentsOf: result)
			}
        } else {
			while true {
				if let result = try await NonSecrets
					.continue(search: handle, in: wallet, count: 100).records {
					items.append(contentsOf: result)
				} else {
					break
				}
			}
        }

        return try items.map {
			var record: T = try JSONDecoder.shared.model($0.value!)
			record.tags = $0.tags!
			return record
		}
    }
}
