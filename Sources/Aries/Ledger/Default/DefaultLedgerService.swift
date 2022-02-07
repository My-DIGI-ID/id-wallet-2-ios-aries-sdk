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
import Indy
import IndyObjc

class DefaultLedgerService: LedgerService {
    func credential(for id: String, with context: Context) async throws -> (String, String) {
        guard let handle = context.pool as? IndyHandle else {
            throw AriesError.invalidType("Pool")
        }
        
        let request = try await Ledger.requestGetCredentialDefinition(for: id, with: nil)
        let result = try await Ledger.submit(request, to: handle)
        return try await Ledger.responseGetCredentialDefinition(result)
    }
    
    func registry(for id: String, with context: Context) async throws -> (String, String) {
        guard let handle = context.pool as? IndyHandle else {
            throw AriesError.invalidType("Pool")
        }
       
        let request = try await Ledger.requestGetRevocationRegistryDefinition(for: id, with: nil)
        let result = try await Ledger.submit(request, to: handle)
        return try await Ledger.responseGetRevocationRegistryDefinition(result)
    }
}
