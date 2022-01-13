/*
 * Copyright 2021 Bundesrepublik Deutschland
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on
 * an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */

import Foundation

protocol MessageService {
    /// Send a (encrypted) message to another agent.
    ///
    /// - Parameters:
    /// 	- message: The message to be sent.
    /// 	- endpoint: The destination of the message.
    ///
    ///  - Returns: The (encrypted) response message, if there is any.
    func send(_ message: Data, to endpoint: String) async throws -> Data?
}
