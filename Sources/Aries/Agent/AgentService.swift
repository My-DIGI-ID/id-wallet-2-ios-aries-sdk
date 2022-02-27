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

public protocol AgentService {
    /// Sets the factory function for the wallet data
    func data(_ factory: @escaping (_ id: String, _ key: String) -> WalletData)
    
    /// First time initialization and setup of the agent
    ///
    /// - Parameter id: The id of the agent and the underlying components.
    /// - Parameter key: The key used for encrypting all data.
    /// - Parameter genesis: The path to the genesis file for ledger connections.
    func initialize(with id: String, _ key: String, _ genesis: String) async throws
    
    /// Destroy everything related to an agent.
    ///
    /// - Parameter id: The id of the agent and the underlying components.
    /// - Parameter key: The key used for encrypting all data.
    func destroy(with id: String, _ key: String) async throws
    
    /// Open the agent for execution of Aries code.
    ///
    /// - Parameter id: The id of the agent and the underlying components.
    /// - Parameter key: The key used for encrypting all data.
    func open(with id: String, _ key: String) async throws
    
    /// Close the previously opened connection.
    ///
    /// - Parameter id: The id of the agent and the underlying components.
    /// - Parameter key: The key used for encrypting all data.
    func close() async throws
    
    /// Execute Aries code.
    ///
    /// - Parameter id: The id of the agent and the underlying components.
    /// - Parameter key: The key used for encrypting all data.
    /// - Returns: The result of the executed code.
    func run<T>(_ closure: (Context) async throws -> T) async throws -> T
}
