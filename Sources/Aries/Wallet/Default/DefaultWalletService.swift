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

/// This a ready-to-use implementation of the ``WalletService`` based on the wallet in Hyperledger Indy.
///
/// These functions directly pass through to the iOS wrapper and the underlying Indy implementation.
public class DefaultWalletService: WalletService {
    public func get(for data: WalletData) async throws -> Wallet {
		guard let data = data as? DefaultWalletData else {
            throw AriesError.invalidType("WalletData")
        }

		return try await Indy.Wallet
			.open(with: data.configuration, data.credentials)
    }

    public func close(_ wallet: Wallet) async throws {
		guard let wallet = wallet as? IndyHandle else {
            throw AriesError.invalidType("Wallet")
        }

		try await Indy.Wallet.close(for: wallet)
    }

    public func create(for data: WalletData) async throws {
		guard let data = data as? DefaultWalletData else {
            throw AriesError.invalidType("WalletData")
        }

		try await Indy.Wallet
			.create(with: data.configuration, data.credentials)
    }

    public func delete(for data: WalletData) async throws {
		guard let data = data as? DefaultWalletData else {
            throw AriesError.invalidType("WalletData")
        }

		try await Indy.Wallet
			.delete(with: data.configuration, data.credentials)
    }

    public static func generateKey(with seed: String? = nil) async throws -> String {
		try await Indy.Wallet.generateKey(seed: seed?.clamp(to: 32))
    }
}
