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

public class DefaultAgentService: AgentService {

    private var context: Context?
    
    public func initialize(with id: String, _ key: String, _ genesis: String) async throws {
        try await Aries.wallet.create(for: data(for: id, key))
        try await Aries.pool.create(with: id, genesis)
    }
    
    public func destroy(with id: String, _ key: String) async throws {
        guard context == nil else {
            throw AriesError.unclosedWallet("Agent must be closed before destruction.")
        }
        
        try await Aries.wallet.delete(for: data(for: id, key))
        try await Aries.pool.delete(for: id)
    }
    
    public func open(with id: String, _ key: String) async throws {
        context = Context(
            wallet: try await Aries.wallet.get(for: data(for: id, key)),
            pool: try await Aries.pool.get(for: id)
        )
    }
    
    public func close() async throws {
        guard let context = context else {
            return            
        }
        try await Aries.wallet.close(context.wallet)
        try await Aries.pool.close(context.pool)
        self.context = nil
    }
        
    public func run<T>(_ closure: (Context) async throws -> T) async throws -> T {
        guard let context = context else {
            throw AriesError.unclosedWallet("Agent must be setup before using it")
        }
        
        return try await closure(context)
    }
    
    private func data(for id: String, _ key: String) -> WalletData {
        DefaultWalletData(
            configuration: WalletConfiguration(id: id),
            credentials: WalletCredentials(key: key)
        )
    }
    
    deinit {
        Task { try? await close() }
    }
}
