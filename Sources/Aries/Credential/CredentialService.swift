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

/// Service for requesting and retrieving credentials.
public protocol CredentialService {
    /// This creates an empty proposal.
    ///
    /// TODO: This function needs to be extended by a configuration or removed entirely.
    /// - Returns: A proposal message for the issuer.
    func proposal() async throws -> CredentialProposalMessage
    
    /// Process a received offer for a credential.
    ///
    /// - Parameter offer: The offer message.
    /// - Parameter connectionId: The id of the connection associated with issuing process.
    /// - Parameter context: The context to execute in.
    /// - Returns: The identifier of the created credential record.
    func process(
        _ offer: CredentialOfferMessage,
        for connectionId: String,
        with context: Context
    ) async throws -> String
    
    /// Create a request for a credential after an offer.
    ///
    /// - Parameter credentialId: The id of the credential record the request should be based on.
    /// - Parameter context: The context to execute in.
    /// - Returns: The sendable request message.
    func request(
        for credentialId: String,
        with context: Context
    ) async throws -> CredentialRequestMessage
    
    /// Process a message containing an issued credential.
    ///
    /// - Parameter credentials: The issue message.
    /// - Parameter context: The context to execute in.
    /// - Returns: The identifier of the created credential record.
    func process(_ credentials: CredentialIssueMessage, with context: Context) async throws -> String
}
