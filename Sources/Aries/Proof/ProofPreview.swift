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

/// Preview of all provable attributes and predicates
public struct ProofPreview: Codable {
    private enum CodingKeys: String, CodingKey {
        case type = "@type"
        case attributes
        case predicates
    }
    
    /// The type identifier of the preview.
    ///
    /// Although this is isn't a message in itself, it is a closed object in terms of the RFC and requires its own type.
    public let type: String
    /// The provable attributes.
    public var attributes: [String]
    /// The provable predicates.
    public var predicates: [String]
    
    public init() {
        self.type = ""
        self.attributes = []
        self.predicates = []
    }
}
