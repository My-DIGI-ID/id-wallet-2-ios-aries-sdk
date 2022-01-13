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

/// Service for all operations on the wallet itself.
public protocol WalletService {
    /// Gets a new reference to the specified wallet.
    ///
    /// Since ``Wallet`` is a reference to the actual wallet, this can be safely called multiple times.
    /// Anyway, this can have implications on memory consumption and performance.
    ///
    /// - Parameters:
    /// 	- configuration: Parameters on how the wallet needs to be accessed.
    /// 	- credentials: Parameters for encryption/decryption.
    ///
    /// - Returns: A new reference to the wallet.
    func get(
        for configuration: WalletConfiguration,
        _ credentials: WalletCredentials
    ) async throws -> Wallet

    /// Invalidates the reference to the wallet and frees all resources.
    ///
    /// - Parameter wallet: The reference to the wallet that needs to be closed.
    func close(_ wallet: Wallet) async throws

    /// Creates a new wallet.
    /// Ideally, this should be called only once per user.
    ///
    /// - Parameters:
    /// 	- configuration: Parameters on how the wallet should be created.
    /// 	- credentials: Parameters for encryption/decryption.
    func create(
        for configuration: WalletConfiguration,
        _ credentials: WalletCredentials
    ) async throws

    /// Deletes the complete wallet.
    /// Note: The wallet must be closed before deletion.
    ///
    /// - Parameters:
    /// 	- configuration: Parameters on how the wallet needs to be accessed.
    /// 	- credentials: Parameters for encryption/decryption.
    func delete(
        for configuration: WalletConfiguration,
        _ credentials: WalletCredentials
    ) async throws

    /// This generates a key which conforms to the ``KeyDerivationMethod/raw`` derivation method,
    /// which should be set to the ``WalletCredentials/key`` property.
    ///
    /// - parameter seed: The seed used for generation. If no seed is provided, a random one is used.
    ///
    /// - returns: A fresh master key for a wallet with ``KeyDerivationMethod/raw`` derivation method.
    func generateKey(with seed: String?) async throws -> String
}
