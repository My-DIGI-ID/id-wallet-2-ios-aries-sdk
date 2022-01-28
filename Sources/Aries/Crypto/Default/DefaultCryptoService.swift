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

class DefaultCryptoService: CryptoService {
	func pack<T: Message>(
		_ message: T,
		for recipients: [String],
		from sender: String?,
		with wallet: Wallet
	) async throws -> Data {
		guard let wallet = wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

		let messageEncoded = try JSONEncoder.shared.encode(message)

		return try await Crypto.pack(
			messageEncoded,
			for: recipients,
			from: sender,
			with: wallet
		)
	}

	func unpack<T: Message>(
		_ message: Data,
		with wallet: Wallet
	) async throws -> T {
		guard let wallet = wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

		return try await Crypto.unpack(message, with: wallet).message
	}
}
