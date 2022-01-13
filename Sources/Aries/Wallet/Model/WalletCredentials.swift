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

/// Structure containing all information for encrypting/decrypting the wallet.
public struct WalletCredentials {
    /// The key used for the actual encryption / decryption of the wallet.
    ///
    /// This is either the starting point in the derivation process **or** the actual master key,
    /// if ``derivationMethodKey`` is set to ``KeyDerivationMethod/raw``.
    /// In this case, the key **must** be generated with ``WalletService/generateKey(with:)``
    public let key: String

    /// The replacent for the current ``key`` to enable rotation.
    ///
    /// This is either the starting point in the derivation process of the new key **or** the actual new master key,
    /// if ``derivationMethodKeyNew`` is set to ``KeyDerivationMethod/raw``.
    /// In this case, the key **must** be generated with ``WalletService/generateKey(with:)``
    public let keyNew: String?

    /// Method to derive the encryption key from ``key``.
    public let derivationMethodKey: KeyDerivationMethod?

    /// Method to derive the new encryption key from ``keyNew``.
    public let derivationMethodKeyNew: KeyDerivationMethod?

    /// Credentials to access the storage.
    ///
    /// This depends on the ``WalletConfiguration/storageType``,
    /// so this can be nil, if a default configuration is supported.
    /// This is case for `default` and since it is the only supported type, we can hardcode this.
    public let credentials: String? = nil

    public init(
        key: String,
        keyNew: String? = nil,
        derivationMethodKey: KeyDerivationMethod? = nil,
        derivationMethodKeyNew: KeyDerivationMethod? = nil
    ) {
        self.key = key
        self.keyNew = keyNew
        self.derivationMethodKey = derivationMethodKey
        self.derivationMethodKeyNew = derivationMethodKeyNew
    }
}
