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

/// The record persisting all infromationen of an ongoing or completed credential issuing.
public struct CredentialRecord: Record {
    public static var type: String = "Aries.Credential"
    public let id: String
    public var credential: String?
    public var definition: String?
    public var schema: String?
    public var connection: String?
    public var revocation: String?
    public var offer: String?
    public var request: String?
    public var metadata: String?
    public var state: CredentialState = .offered
    public var attributes: [CredentialAttribute] = []
    public var tags: [String: String] = [:]
    
    init(id: String = UUID().uuidString) {
        self.id = id
    }
}
