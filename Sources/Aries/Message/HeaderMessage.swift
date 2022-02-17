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

/// This message is used the decode only the head of a message, which is given regardless of the type.
///
/// This allows to determinate the right message type to decode it in the right model.
public struct HeaderMessage: Message {
    private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
    }
    
    public let id: String
    public let type: String
}
