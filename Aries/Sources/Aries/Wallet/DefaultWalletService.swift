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

/// This a ready-to-use implementation of the ``WalletService`` based on the wallet in Hyperledger Indy.
///
/// These functions directly pass through to the iOS wrapper and the underlying Indy implementation.
class DefaultWalletService: WalletService {
    func get(
        for configuration: WalletConfiguration,
        _ credentials: WalletCredentials
    ) async throws -> Wallet {
        let conf = try JSONEncoder.shared.string(configuration)
        let cred = try JSONEncoder.shared.string(credentials)
        let handle = try await Indy.Wallet.open(with: conf, cred)
        return Wallet(id: Int(handle))
    }

    func close(_ wallet: Wallet) async throws {
        try await Indy.Wallet.close(for: Int32(wallet.id))
    }

    func create(
        for configuration: WalletConfiguration,
        _ credentials: WalletCredentials
    ) async throws {
        let conf = try JSONEncoder.shared.string(configuration)
        let cred = try JSONEncoder.shared.string(credentials)
        try await Indy.Wallet.create(with: conf, cred)
    }

    func delete(
        for configuration: WalletConfiguration,
        _ credentials: WalletCredentials
    ) async throws {
        let conf = try JSONEncoder.shared.string(configuration)
        let cred = try JSONEncoder.shared.string(credentials)
        try await Indy.Wallet.delete(with: conf, cred)
    }

    func generateKey(with seed: String?) async throws -> String {
        // Pure gold: Indy does not document it anywhere,
        // but the seed must be exactly 32 characters long.
        let adjusted = seed?.clamp(to: 32)
        let configEncoded = try JSONEncoder.shared.string(["seed": adjusted])
        return try await Indy.Wallet.generateKey(with: configEncoded)
    }
}
