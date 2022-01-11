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

/// Service for all operations that process records.
public protocol RecordService {
    /// Add a new record to the referenced wallet.
    ///
    /// - Parameters:
    /// 	- record: The record to be inserted
    /// 	- wallet: The wallet where the record should be added to
    func add<T: Record>(_ record: T, to wallet: Wallet) async throws

    /// Get a single record for a specific id and type from the referenced wallet.
    ///
    /// - Parameters:
    /// 	- type: The class of the record to get
    /// 	- id: The unique id of the record
    /// 	- wallet: The wallet where the record is stored
    func get<T: Record>(_ type: T.Type, for id: String, from wallet: Wallet) async throws -> T

    /// Override an existing record with the same type and id in the referenced wallet.
    ///
    /// - Parameters:
    /// 	- record: The record to be updated
    /// 	- wallet: The wallet where the record should be updated
    func update<T: Record>(_ record: T, in wallet: Wallet) async throws

    /// Delete the record with the type and unique id in the referenced wallet.
    ///
    /// - Parameters:
    /// 	- type: The class of the record to be deleted
    /// 	- id: The unique id of the record
    /// 	- wallet: The wallet where the record should be deleted from
    func delete<T: Record>(_ type: T.Type, with id: String, in wallet: Wallet) async throws

    /// Search in the wallet for records of a specific type, optionally with a filter query and specific ranges.
    ///
    /// - Parameters:
    /// 	- type: The class of the record to be deleted
    /// 	- wallet: The wallet to search in
    /// 	- query: The filter that should be applied. For no filter use ``SearchQuery/none``.
    ///		- count: The maximum amount of records to be fetched.
    ///		- skip: The amout of records to be skipped.
    func search<T: Record>(
        _ type: T.Type,
        in wallet: Wallet,
        with query: SearchQuery,
        count: Int?,
        skip: Int?
    ) async throws -> [T]
}
