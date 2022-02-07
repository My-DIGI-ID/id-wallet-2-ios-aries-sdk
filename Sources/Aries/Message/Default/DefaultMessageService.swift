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

class DefaultMessageService: MessageService {
    private static let contentType = "application/ssi-agent-wire"

	var session: URLSession = .shared

    func sendReceive<I: Message, O: Message>(
        _ request: MessageRequest<I>,
        with wallet: Wallet
    ) async throws -> MessageResponse<O> {
        guard let handle = wallet as? IndyHandle else {
            throw AriesError.invalidType("Wallet")
        }
        
        let content: Data? = try await sendReceive(request, with: wallet)
        
        guard let data = content else {
            throw AriesError.notFound("Response")
        }
        
        let unpacked: UnpackedMessage<String> = try await Crypto.unpack(data, with: handle)

        return MessageResponse(
            message: try JSONDecoder.shared.model(unpacked.message),
            sender: unpacked.keySender
        )
    }
    
    func send<I: Message>(_ request: MessageRequest<I>, with wallet: Wallet) async throws {
        try await sendReceive(request, with: wallet)
    }
    
    @discardableResult
    private func sendReceive<I: Message>(
        _ request: MessageRequest<I>,
        with wallet: Wallet
    ) async throws -> Data? {
        guard let handle = wallet as? IndyHandle else {
            throw AriesError.invalidType("Wallet")
        }
        
        let packed: Data = try await Crypto.pack(request.message, for: request.recipientKeys, from: request.senderKey, with: handle)
        
        guard let url = URL(string: request.endpoint) else {
            throw AriesError.invalidUrl(request.endpoint)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(Self.contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = packed
        
        return try await withCheckedThrowingContinuation { cont in
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    cont.resume(throwing: AriesError.transport(error))
                } else if let response = response as? HTTPURLResponse {
                    if (200 ..< 300).contains(response.statusCode) {
                        cont.resume(returning: data)
                    } else {
                        cont.resume(returning: nil)
                    }
                } else {
                    cont.resume(throwing: AriesError.illegalResult("send(_:to:)"))
                }
            }.resume()
        }
    }
}
