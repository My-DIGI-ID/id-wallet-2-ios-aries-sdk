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

/// Service for handling connections to the underlying pool of the ledger.
public protocol PoolService {
    /// Create a configuration for later connections.
    ///
    /// - Parameter name: The name of the configuration
    /// - Parameter genesis: The path to the genesis file needed to establish the connection.
    func create(with name: String, _ genenis: String) async throws
    
    /// Establish a connection to the pool defined in the configuration.
    ///
    /// - Parameter name: The name of the configuration
    /// - Returns: The pool connection.
    func get(for name: String) async throws -> Pool
    
    /// Close an existing connection to a pool
    ///
    /// - Parameter pool: The pool connection to be closed.
    func close(_ pool: Pool) async throws
    
    /// Delete a configuration.
    ///
    /// - Parameter name: The name of the configuration.
    /// - Warning: Connections using this configuration must be closed before deletion.
    func delete(for name: String) async throws
}
