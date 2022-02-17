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

public protocol MessageService {
    /// Sends a message to another agent with a potential response.
    ///
    /// - Parameter request: All information needed to send the request.
    /// - Parameter wallet: Used for encrypted communication
    ///
    /// - Returns: The response message, if there is any.
    func sendReceive<I: Message, O: Message>(
        _ request: MessageRequest<I>,
        with wallet: Wallet
    ) async throws -> MessageResponse<O>
    
    /// Sends a message to another agent with a potential response.
    ///
    /// - Parameter request: All information needed to send the request.
    /// - Parameter wallet: Used for encrypted communication
    ///
    /// - Returns: The response message, if there is any.
    func send<I: Message>(_ request: MessageRequest<I>, with wallet: Wallet) async throws
    
    /// Receive a packed message, which arrived over another channel than direct response.
    ///
    /// - Parameter data: The encoded message.
    /// - Parameter wallet: The wallet used to unpack the and decode the message.
    ///
    /// - Returns: The decoded message with the anticipated type.
    func receive<O: Message>(_ data: Data, with wallet: Wallet) async throws -> MessageResponse<O>
}
