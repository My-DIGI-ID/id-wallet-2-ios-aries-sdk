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

class DefaultMessageService: MessageService {
    private static let contentType = "application/ssi-agent-wire"

	var session: URLSession = .shared

    func send(_ message: Data, to endpoint: String) async throws -> Data? {
        guard let url = URL(string: endpoint) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(Self.contentType, forHTTPHeaderField: "Content-Type")
        request.httpBody = message

        return try await withCheckedThrowingContinuation { cont in
            session.dataTask(with: request) { data, response, error in
                if let error = error {
					cont.resume(throwing: AriesError.transport(error))
                } else if let response = response as? HTTPURLResponse, (200 ..< 400).contains(response.statusCode) {
					cont.resume(returning: data)
                } else {
					cont.resume(throwing: AriesError.illegalResult("send(_:to:)"))
                }
            }
        }
    }
}
