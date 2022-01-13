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

extension WalletStorageConfiguration: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(path, forKey: .path)
        try container.encode(url, forKey: .url)
        try container.encode(scheme, forKey: .scheme)
        try container.encode(database, forKey: .database)
        try container.encode(tls, forKey: .tls)
        try container.encodeIfPresent(maxConnections, forKey: .maxConnections)
        try container.encodeIfPresent(minIdleCount, forKey: .mindIdleCount)
        try container.encodeIfPresent(timeout, forKey: .timeout)
    }

    private enum CodingKeys: String, CodingKey {
        case path
        case url
        case scheme = "wallet_scheme"
        case database = "database_name"
        case tls
        case maxConnections = "max_connections"
        case mindIdleCount = "min_idle_count"
        case timeout = "connection_timeout"
    }
}
