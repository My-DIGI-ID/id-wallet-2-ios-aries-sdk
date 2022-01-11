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

/// Structure containing all parameters for the wallet itself.
public struct WalletConfiguration {
    /// The unique identifier of your wallet.
    public let id: String

    /// Parameters for the underlying storage of the wallet.
    ///
    /// The content actually varies depending on `storageType`,
    /// but since we only support the default one, this is well defined.
    public let storageConfiguration: WalletStorageConfiguration?

    /// This defines how the wallet is *implemented*.
    /// The default is `default`, which leads to local files with a SQLite database.
    ///
    /// Theoretically, it is possible to register other types of storage,
    /// but this is out of scope so we just leave this hardcoded.
    public let storageType: String = "default"

    public init(
        id: String,
        storageConfiguration: WalletStorageConfiguration? = nil
    ) {
        self.id = id
        self.storageConfiguration = storageConfiguration
    }
}
