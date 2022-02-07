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
    private static let charPadding = "="
    private static let char62 = "+"
    private static let char63 = "/"
    private static let charUrl62 = "-"
    private static let charUrl63 = "_"
    
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
			data: encode(signatureData),
			signer: key,
			signature: encode(signature)
		)
	}

	static func verify(_ decorator: SignatureDecorator) async throws -> Data {
        let signature = try decode(decorator.signature)
        let signatureData = try decode(decorator.data)

		let valid = try await Crypto.verifiy(
			signature,
			for: signatureData,
			with: decorator.signer)

		guard valid else {
			throw AriesError.invalidSignature
		}

		return signatureData.advanced(by: 8)
	}
    
    private static func encode(_ data: Data) -> String {
        let string = data.base64EncodedString()
            .split(separator: charPadding.first!)[0]
            .replacingOccurrences(of: char62, with: charUrl62)
            .replacingOccurrences(of: char63, with: charUrl63)
            
        return string.padding(
            toLength: string.count + (4 - string.count % 4) % 4,
            withPad: charPadding,
            startingAt: 0
        )
    }
    
    private static func decode(_ string: String) throws -> Data {
        var string = string
            .replacingOccurrences(of: charUrl62, with: char62)
            .replacingOccurrences(of: charUrl63, with: char63)
        
        switch string.count % 4 {
        case 0: break
        case 2: string += charPadding
        case 3: string += charPadding + charPadding
        default: throw AriesError.decoding("Invalid format of base64")
        }
        
        return Data(base64Encoded: string)!
    }
<<<<<<< HEAD
=======
    
>>>>>>> 7c2e85ab46f38081f2c0bd411f3c37016ffcfb9a
}
