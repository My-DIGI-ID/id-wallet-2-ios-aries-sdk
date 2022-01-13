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

/// Structure containing all parameters on how the underlying storage of the wallet is handled.
///
/// Since `default` is the only supported storage type, these parameters define,
/// where the local files are stored and how the SQLite database is accessed.
public struct WalletStorageConfiguration {
    public let path: String
    public let url: String
    public let scheme: String
    public let database: String
    public let tls: String
    public let maxConnections: Int?
    public let minIdleCount: Int?
    public let timeout: Int?

    public init(
        path: String,
        url: String,
        scheme: String,
        database: String,
        tls: String,
        maxConnections: Int? = nil,
        minIdleCount: Int? = nil,
        timeout: Int? = nil
    ) {
        self.path = path
        self.url = url
        self.scheme = scheme
        self.database = database
        self.tls = tls
        self.maxConnections = maxConnections
        self.minIdleCount = minIdleCount
        self.timeout = timeout
    }
}
