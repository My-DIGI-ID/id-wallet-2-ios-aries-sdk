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

/// Message completing DID exchange in response to a request.
public struct ConnectionResponseMessage: Message {
    private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case signature = "connection~sig"
    }

    /// The unique identifier
    public let id: String
    /// The type of message
    public let type: String
    /// Signature of the request
    public let signature: SignatureDecorator

	init(
        id: String = UUID().uuidString,
        signature: SignatureDecorator
    ) {
        self.id = id
        self.type = "https://didcomm.org/connections/1.0/response"
        self.signature = signature
	}
}
