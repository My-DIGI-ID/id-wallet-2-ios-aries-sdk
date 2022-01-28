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

/// Service for encrypting / decrypting messages sent between agents.
public protocol CryptoService {
	/// Encrypt a message for sending.
	///
	/// - Parameters:
	/// 	- message: The message to needs to be encrypted.
	/// 	- recipients: The list of verkeys of the recepients. Packing is based on PKE so we need to know these.
	/// 	- sender: The verkey of sender.
	/// 	- wallet: The wallet that processes the actual packing.
	func pack<T: Message>(
		_ message: T,
		for recipients: [String],
		from sender: String?,
		with wallet: Wallet
	) async throws -> Data

	/// Decrypt a received message.
	///
	/// - Parameters:
	/// 	- message: The message to be decrypted.
	/// 	- wallet: The wallet that processes the actual unpacking.
	func unpack<T: Message>(
		_ message: Data,
		with wallet: Wallet
	) async throws -> T
}

extension CryptoService {
	func pack<T: Message>(
		_ message: T,
		for recipients: [String],
		with wallet: Wallet
	) async throws -> Data {
		try await pack(message, for: recipients, from: nil, with: wallet)
	}
}