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

public protocol AgentService {
    
    func initialize(with id: String, _ key: String, _ genesis: String) async throws
    
    func destroy(with id: String, _ key: String) async throws
    
    func open(with id: String, _ key: String) async throws
    
    func close() async throws
    
    func run<T>(_ closure: (Context) async throws -> T) async throws -> T
}
