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

/// Service for handling proofs.
protocol ProofService {
    /// Process a request for proof.
    ///
    /// - Parameter request: The proof request.
    /// - Parameter connectionId: The identifier of the connection associated with the proof.
    /// - Parameter context: The context to operate in.
    /// - Returns: The identifier of the created proof record.
    func process(
        _ request: ProofRequestMessage,
        for connectionId: String,
        with context: Context
    ) async throws -> String
    
    /// Create a proof presentation:
    ///
    /// - Parameter id: The identifier of the proof record.
    /// - Parameter credentials: The credential to be proofed.
    /// - Parameter context: The context to operate in.
    /// - Returns: The message containing the presentation.
    func presentation(
        for id: String,
        containing credentials: String,
        with context: Context
    ) async throws -> ProofPresentationMesssage
}
