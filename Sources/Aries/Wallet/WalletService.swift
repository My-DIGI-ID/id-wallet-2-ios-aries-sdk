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

/// Service for all operations on the wallet itself.
public protocol WalletService {
    /// Gets a new reference to the specified wallet.
    ///
    /// - Parameter data: Parameters on how the wallet needs to be accessed.
    /// - Returns: A new reference to the wallet.
    func get(for data: WalletData) async throws -> Wallet

    /// Invalidates the reference to the wallet and frees all resources.
    ///
    /// - Parameter wallet: The reference to the wallet that needs to be closed.
    func close(_ wallet: Wallet) async throws

    /// Creates a new wallet.
    /// Ideally, this should be called only once per user.
    ///
	/// - Parameter data: Parameters on how the wallet should to be created.
	func create(for data: WalletData) async throws

    /// Deletes the complete wallet.
    /// Note: The wallet must be closed before deletion.
	///
    /// - Parameter data: Parameters on how the wallet needs to be accessed.
	func delete(for data: WalletData) async throws
}
