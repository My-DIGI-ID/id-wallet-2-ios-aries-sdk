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

/// Decorator for indicating that a response message is valid in the HTTP responses.
public struct TransportDecorator: Decorator {
    public enum ReturnMode: String, Codable {
        case all
        case none
        case thread
    }
    
    private enum CodingKeys: String, CodingKey {
        case mode = "return_route"
    }
    
    /// The mode when a direct response is expected
    public let mode: ReturnMode
    
    public init(mode: ReturnMode = .all) {
        self.mode = mode
    }
}
