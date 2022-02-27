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

import Indy

/// Service for all operations that process records.
public protocol RecordService {
    /// Add a new record to the referenced wallet.
    ///
    /// - Parameters:
    /// 	- record: The record to be inserted
    /// 	- context: The context to operate in.
    func add<T: Record>(_ record: T, with context: Context) async throws

    /// Get a single record for a specific id and type from the referenced wallet.
    ///
    /// - Parameters:
    /// 	- type: The class of the record to get
    /// 	- id: The unique id of the record
    ///     - context: The context to operate in.
    func get<T: Record>(_: T.Type, for id: String, with context: Context) async throws -> T

    /// Override an existing record with the same type and id in the referenced wallet.
    ///
    /// - Parameters:
    /// 	- record: The record to be updated
    ///     - context: The context to operate in.
    func update<T: Record>(_ record: T, with context: Context) async throws

    /// Delete the record with the type and unique id in the referenced wallet.
    ///
    /// - Parameters:
    /// 	- type: The class of the record to be deleted
    /// 	- id: The unique id of the record
    ///     - context: The context to operate in.
    func delete<T: Record>(_: T.Type, for id: String, with context: Context) async throws

    /// Search in the wallet for records of a specific type, optionally with a filter query and specific ranges.
    ///
    /// - Parameters:
    /// 	- type: The class of the record to be deleted
    ///     - context: The context to operate in.
    /// 	- query: The filter that should be applied. For no filter use ``SearchQuery/none``.
    ///		- count: The maximum amount of records to be fetched.
    ///		- skip: The amout of records to be skipped.
    func search<T: Record>(
        _: T.Type,
        with context: Context,
        matching query: SearchQuery,
        count: Int?,
        skip: Int?
    ) async throws -> [T]
}
