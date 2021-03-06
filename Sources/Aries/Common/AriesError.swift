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

/// Enumeration for all possible Aries errors with optional extra information.
public enum AriesError: Error {
    case encoding(String)
    case decoding(String)
    case transport(Error)
    case notFound(String)

    case illegalResult(String)
    case illegalState(String)
    
    case invalidUrl(String)
    case invalidType(String)
    case invalidKey(String)
	case invalidSignature
    
    case unclosedWallet(String)
}
