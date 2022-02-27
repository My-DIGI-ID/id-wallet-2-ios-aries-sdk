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

/// Message for handling information associated to this provisioned agent.
public protocol ProvisioningService {
    /// Get the record containing the provisioning data.
    ///
    /// - Parameter context: The context to run in.
    /// - Returns: The provisioning record.
    func getRecord(with context: Context) async throws -> ProvisioningRecord
    
    /// Update the endpoint information of this agent.
    ///
    /// - Parameter endpoint: The new endpoint
    /// - Parameter context: The context to run in.
    func update(_ endpoint: Endpoint, with context: Context) async throws
    
    /// Update the presentable information of the subject owning this agent.
    ///
    /// - Parameter owner: The new owner information.
    /// - Parameter context: The context to run in.
    func update(_ owner: Owner, with context: Context) async throws
    
    /// Update the identifier of the master secret.
    ///
    /// - Parameter masterSecretId: The identifier of the new master secret.
    /// - Parameter context: The context to run in.
    func update(_ masterSecretId: String, with context: Context) async throws
}
