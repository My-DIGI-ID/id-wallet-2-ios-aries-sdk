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

// swiftlint:disable duplicate_imports

@testable import Aries
import protocol Aries.Wallet
import Indy
import IndyObjc
import XCTest

class AgentServiceTests: XCTestCase {

    let agentService: AgentService = DefaultAgentService()
    
    func test_setup_and_destroy() async throws {
        // Arrange
        let id = "ID"
        let key = "KEY"
        let genesis = Bundle.module.path(forResource: "idw_eesditest", ofType: nil, inDirectory: "Resource")!
        
        // Act
        try await agentService.initialize(with: id, key, genesis)
        try await agentService.open(with: id, key)
        try await agentService.run { _ in }
        try await agentService.close()
        try await agentService.destroy(with: id, key)
    }
}
