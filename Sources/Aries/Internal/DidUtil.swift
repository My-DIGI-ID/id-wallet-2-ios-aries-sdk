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
import CoreText

enum DidUtil {

	private static let regexVerkeyFull = "^[1-9A-HJ-NP-Za-km-z]{43,44}$"
	private static let regexVerkeyAbbreviated = "^~[1-9A-HJ-NP-Za-km-z]{22}$"
	private static let regexDid = "^did:([a-z]+):([a-zA-z\\d]+)"
	private static let regexDidKey = "^did:key:([1-9A-HJ-NP-Za-km-z]+)"
	private static let prefixDidKey = "did:key"
	private static let prefixBase58 = "z"
	private static let prefixED25519: [UInt8] = [0xed, 0x01]

	static func did(from method: String, _ identifier: String) -> String {
		"did:\(method):\(identifier)"
	}

	static func isFull(verkey: String) -> Bool {
		verkey.range(of: regexVerkeyFull, options: .regularExpression) != nil
	}

	static func isAbbreviated(verkey: String) -> Bool {
		verkey.range(of: regexVerkeyAbbreviated, options: .regularExpression) != nil
	}

	static func isVerkey(_ verkey: String) -> Bool {
		isAbbreviated(verkey: verkey) || isFull(verkey: verkey)
	}

	static func isDidKey(_ key: String) -> Bool {
		key.range(of: regexDidKey, options: .regularExpression) != nil
	}

	/*
	- TODO: We need Base58 to implement those functions.
	public static func convertDidKeyToVerkey(_ didKey: String) -> String {
		""
	}
	
	public static func convertVerkeyToDidKey(_ verkey: String) -> String {
		""
	}
    */
}
