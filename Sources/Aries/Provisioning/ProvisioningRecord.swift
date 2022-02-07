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

// swiftlint:disable inclusive_language

import Foundation

public struct ProvisioningRecord: Record {
	public static let uniqueId: String = "SingleRecord"
	public static let type: String = "ProvisioningRecord"

	public var id: String { Self.uniqueId }
	public var tags: [String: String] = [:]

	public var owner: Owner?
	public var endpoint: Endpoint?
    public var masterSecretId: String?
}
