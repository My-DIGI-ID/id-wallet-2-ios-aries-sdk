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

/// This describes cryptographic material for various use cases related to a DID document.
public enum VerificationMethod: Codable {
    case reference(String)
    case embedded(
        id: String,
        controller: String,
        type: String,
        key: String? = nil,
        jwk: String? = nil,
        multibase: String? = nil
    )
    
    private enum CodingKeys: String, CodingKey {
        case id
        case controller
        case type
        case key = "publicKey"
        case jwk = "publicKeyJwk"
        case multibase = "publicKeyMultibase"
    }
    
    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(), let reference = try? container.decode(String.self) {
            self = .reference(reference)
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self = .embedded(
                // According to W3C, "id" and "controller" are required, but ACA-PY omits them for some reason.
                // We stick to the specification.
                id: try container.decodeIfPresent(String.self, forKey: .id) ?? "",
                controller: try container.decodeIfPresent(String.self, forKey: .controller) ?? "",
                type: try container.decode(String.self, forKey: .type),
                key: try container.decodeIfPresent(String.self, forKey: .key),
                jwk: try container.decodeIfPresent(String.self, forKey: .jwk),
                multibase: try container.decodeIfPresent(String.self, forKey: .multibase)
            )
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if case let .reference(reference) = self {
            var container = encoder.singleValueContainer()
            try container.encode(reference)
        } else if case let .embedded(id, controller, type, key, jwk, multibase) = self {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(controller, forKey: .controller)
            try container.encode(type, forKey: .type)
            try container.encodeIfPresent(key, forKey: .key)
            try container.encodeIfPresent(jwk, forKey: .jwk)
            try container.encodeIfPresent(multibase, forKey: .multibase)
        }
    }
}
