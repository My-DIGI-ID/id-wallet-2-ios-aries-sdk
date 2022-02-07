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

class DefaultAgentService: AgentService {
    
    private var data: WalletData?
    private var poolName: String?
    private var context: Context?
    
    func setup(with id: String, _ key: String, _ genesis: String) async throws {
        let data = DefaultWalletData(
            configuration: WalletConfiguration(id: id),
            credentials: WalletCredentials(key: key)
        )
        
        // Try create wallet and pool config, if it fails, they already exist.
        try? await Aries.wallet.create(for: data)
        try? await Aries.pool.create(with: id, genesis)
        
        // Get handles
        let wallet = try await Aries.wallet.get(for: data)
        let pool = try await Aries.pool.get(for: id)
        
        self.data = data
        self.poolName = id
        self.context = Context(wallet: wallet, pool: pool)
    }
    
    func destroy() async throws {
        guard let data = data, let poolName = poolName, let context = context else {
            throw AriesError.notSetup("Agent can not be destroyed without setup.")
        }
        
        try await Aries.wallet.close(context.wallet)
        try await Aries.wallet.delete(for: data)
        try await Aries.pool.close(context.pool)
        try await Aries.pool.delete(for: poolName)
    }
    
    func run<T>(_ closure: (Context) async throws -> T) async throws -> T {
        guard let context = context else {
            throw AriesError.notSetup("Agent must be setup before using it")
        }

        return try await closure(context)
    }
    
    deinit {
        guard let context = context else {
            return
        }
        
        Task {
            try? await Aries.wallet.close(context.wallet)
            try? await Aries.pool.close(context.pool)
        }
    }
}
