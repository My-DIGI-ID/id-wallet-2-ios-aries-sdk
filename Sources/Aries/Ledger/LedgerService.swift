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

/// Service definition for reading data from the ledger.
public protocol LedgerService {
    /// Gets the definition of the credential from the ledger.
    ///
    /// - Parameter id: The identifier of the of registry
    /// - Parameter context: The context containing the ledger connection.
    /// - Returns: The identifier and definition of the credential.
    func credential(for id: String, with context: Context) async throws -> String
    
    /// Gets the definition of the revocation registry from the ledger.
    ///
    /// - Parameter id: The identifier of the of registry.
    /// - Parameter context: The context containing the ledger connection.
    /// - Returns: The identifier and defintion of the revocation registry
    func registry(for id: String, with context: Context) async throws -> String
}
