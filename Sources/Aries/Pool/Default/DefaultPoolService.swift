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

class DefaultPoolService: PoolService {
    func create(with name: String, _ genenis: String) async throws {
        try await Indy.Pool.create(with: name, genenis)
    }
    
    func get(for name: String) async throws -> Pool {
        try await Indy.Pool.open(with: name)
    }
    
    func close(_ pool: Pool) async throws {
        guard let handle = pool as? IndyHandle else {
            throw AriesError.invalidType("Pool")
        }
        
        try await Indy.Pool.close(handle)
    }
    
    func delete(for name: String) async throws {
        try await Indy.Pool.delete(for: name)
    }
}
