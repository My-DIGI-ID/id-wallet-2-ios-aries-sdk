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

enum SignatureUtil {
	private static let defaultSignatureType = "did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/signature/1.0/ed25519Sha512_single"

	static func sign(
		_ data: Data,
		with key: String,
		_ wallet: Wallet
	) async throws -> SignatureDecorator {
		guard let handle = wallet as? IndyHandle else {
			throw AriesError.invalidType("Wallet")
		}

		let nonce = Int64(Date().timeIntervalSince1970)
		var signatureData = Data(withUnsafeBytes(of: nonce.bigEndian, Array.init))
		signatureData.append(contentsOf: data)
		let signature = try await Crypto.sign(signatureData, with: key, handle)

		return SignatureDecorator(
			type: Self.defaultSignatureType,
			data: signatureData.base64EncodedString(),
			signer: key,
			signature: signature.base64EncodedString()
		)
	}

	static func verify(_ decorator: SignatureDecorator) async throws -> Data {
		guard let signature = Data(base64Encoded: decorator.signature),
            let signatureData = Data(base64Encoded: decorator.data) else {
			throw AriesError.decoding("Signature")
		}

		let valid = try await Crypto.verifiy(
			signature,
			for: signatureData,
			with: decorator.signer)

		guard valid else {
			throw AriesError.invalidSignature
		}

		return signatureData.advanced(by: 8)
	}
}
