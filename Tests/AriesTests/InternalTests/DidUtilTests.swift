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
@testable import Aries
import Indy
import IndyObjc
import XCTest

class DidUtilTests: XCTestCase {

	private let verkeyFull0 = "MeHaPyPGsbBCgMKo13oWK7MeHaPyPGsbBCgMKo13oWK7"
	private let verkeyFull1 = "XHhCzrFBTvrh2GsmHWRW4bpGYHdiPJbagSTFEMvFayc"
	private let verkeyAbbreviated = "~MeHaPyPGsbBCgMKo13oWK7"
	private let didKey = "did:key:z6MkhaXgBZDvotDkL5257faiztiGiC2QtKLGpbnnEGta2doK"
	private let verkeyOriginal = "8HH5gYEeNc3z7PYXmd54d4x6qAfCNrqQqEB3nS7Zfu7K"
	private let didKeyDerived = "did:key:z6MkmjY8GnV5i9YTDtPETC2uUAW6ejw3nk5mXF5yci5ab7th"
	private let secp256k1 = "did:key:zQ3shokFTS3brHcDQrn82RUDfCZESWL1ZdCEJwekUDPQiYBme"

	func test_detect_verkey_full() {
		XCTAssertTrue(DidUtil.isFull(verkey: verkeyFull0))
		XCTAssertTrue(DidUtil.isFull(verkey: verkeyFull1))
		XCTAssertFalse(DidUtil.isFull(verkey: ""))
		XCTAssertFalse(DidUtil.isFull(verkey: verkeyAbbreviated))
	}

	func test_detect_verkey_abbreviated() {
		XCTAssertTrue(DidUtil.isAbbreviated(verkey: verkeyAbbreviated))
		XCTAssertFalse(DidUtil.isAbbreviated(verkey: ""))
		XCTAssertFalse(DidUtil.isAbbreviated(verkey: verkeyFull0))
		XCTAssertFalse(DidUtil.isAbbreviated(verkey: verkeyFull1))
	}

	func test_detect_verkey() {
		XCTAssertTrue(DidUtil.isVerkey(verkeyFull0))
		XCTAssertTrue(DidUtil.isVerkey(verkeyFull1))
		XCTAssertTrue(DidUtil.isVerkey(verkeyAbbreviated))
		XCTAssertFalse(DidUtil.isVerkey(""))
	}

	func test_detect_didkey() {
		XCTAssertTrue(DidUtil.isDidKey(didKey))
		XCTAssertTrue(DidUtil.isDidKey(secp256k1))
		XCTAssertFalse(DidUtil.isDidKey(verkeyFull0))
		XCTAssertFalse(DidUtil.isDidKey(""))
	}

	/*
	- TODO: Uncommented when functions are implemented. This requires a Base58 implementation.
	func test_convert_didkey_to_verkey() {
		// Arrange
		let expected = verkeyOriginal
		
		// Act
		let actual = DidUtil.convertDidKeyToVerkey(didKeyDerived)

		// Assert
		XCTAssertEqual(actual, expected)
	}
	
	func test_convert_verkey_to_didkey() {
		// Arrange
		let expected = didKeyDerived
		
		// Act
		let actual = DidUtil.convertDidKeyToVerkey(verkeyOriginal)
		
		// Assert
		XCTAssertEqual(actual, expected)
	}*/
}
