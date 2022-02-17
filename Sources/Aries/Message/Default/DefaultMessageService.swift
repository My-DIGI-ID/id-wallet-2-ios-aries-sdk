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

public class DefaultMessageService: MessageService {
    private static let contentType = "application/ssi-agent-wire"

	public var session: URLSession = .shared

    public func sendReceive<I: Message, O: Message>(
        _ request: MessageRequest<I>,
        with wallet: Wallet
    ) async throws -> MessageResponse<O> {
        let content: Data? = try await sendReceive(request, with: wallet)
        
        guard let data = content else {
            throw AriesError.notFound("Response")
        }
        
        return try await receive(data, with: wallet)
    }
    
    public func send<I: Message>(_ request: MessageRequest<I>, with wallet: Wallet) async throws {
        try await sendReceive(request, with: wallet)
    }
    
    public func receive<O: Message>(_ data: Data, with wallet: Wallet) async throws -> MessageResponse<O> {
        guard let handle = wallet as? IndyHandle else {
            throw AriesError.invalidType("Wallet")
        }
        
        let unpacked: UnpackedMessage<String> = try await Crypto.unpack(data, with: handle)
        
        return MessageResponse(
            message: try JSONDecoder.shared.model(unpacked.message),
            sender: unpacked.keySender
        )
    }
    
    @discardableResult
    private func sendReceive<I: Message>(
        _ request: MessageRequest<I>,
        with wallet: Wallet
    ) async throws -> Data? {
        guard let handle = wallet as? IndyHandle else {
            throw AriesError.invalidType("Wallet")
        }
        
        let packed: Data = try await Crypto.pack(
            request.message, for: request.recipientKeys, from: request.senderKey, with: handle)
        
        guard let url = URL(string: request.endpoint) else {
            throw AriesError.invalidUrl(request.endpoint)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = packed
        
        urlRequest.addValue(Self.contentType, forHTTPHeaderField: "Content-Type")
        request.headers.forEach { (k, v) in
            urlRequest.addValue(v, forHTTPHeaderField: k)
        }        
        
        return try await withCheckedThrowingContinuation { cont in
            session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    cont.resume(throwing: AriesError.transport(error))
                } else if let response = response as? HTTPURLResponse {
                    switch response.statusCode {
                    case 200 ..< 300:
                        cont.resume(returning: data)
                    case 500..<600:
                        cont.resume(throwing: AriesError.notFound("Server Error"))
                    default:
                        cont.resume(returning: nil)
                    }
                } else {
                    cont.resume(throwing: AriesError.illegalResult("send(_:to:)"))
                }
            }.resume()
        }
    }
}
