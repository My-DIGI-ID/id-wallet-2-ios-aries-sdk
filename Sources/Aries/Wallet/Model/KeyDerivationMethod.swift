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

/// Contains all supported types of derivation for the key used to encrypt the wallet.
public enum KeyDerivationMethod {
    /// Default and most secure derivation method.
    case argon2imod

    /// Similar to ``argon2imod`` but faster and less secure.
    case argon2iint

    /// Raw skips derivation and enables usage of custom keys.
    ///
    /// Use ``WalletCredentials/generateKey(seed:)`` to generate one and set it to
    /// ``WalletCredentials/key``.
    case raw

    /// This is the string the Indy wallet recognizes.
    ///
    /// We implement this as a computed property to not expose these keys outside of the library.
    internal var identifier: String {
        switch self {
        case .argon2imod: return "ARGON2I_MOD"
        case .argon2iint: return "ARGON2I_INT"
        case .raw: return "RAW"
        }
    }
}
