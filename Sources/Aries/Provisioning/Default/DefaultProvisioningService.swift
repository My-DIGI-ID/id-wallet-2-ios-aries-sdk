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

import Indy
import IndyObjc

public class DefaultProvisioningService: ProvisioningService {

	private let recordService: RecordService

	init(recordService: RecordService) {
		self.recordService = recordService
	}
    
    public func getRecord(with context: Context) async throws -> ProvisioningRecord {
        do {
            return try await recordService.get(
                ProvisioningRecord.self,
                for: ProvisioningRecord.uniqueId,
                with: context
            )
        } catch {
            let record = ProvisioningRecord()
            try await recordService.add(record, with: context)
            return record
        }
	}
    
    public func update(_ owner: Owner, with context: Context) async throws {
        var record = try await getRecord(with: context)
        record.owner = owner
        try await recordService.update(record, with: context)
    }
    
    public func update(_ endpoint: Endpoint, with context: Context) async throws {
        var record = try await getRecord(with: context)
        record.endpoint = endpoint
        try await recordService.update(record, with: context)
    }
    
    public func update(_ masterSecretId: String, with context: Context) async throws {
        guard let handle = context.wallet as? IndyHandle else {
            throw AriesError.invalidType("Wallet")
        }
        
        var record = try await getRecord(with: context)
        record.masterSecretId = try await Indy.AnonCreds.Prover.masterSecret(with: masterSecretId, in: handle)
        try await recordService.update(record, with: context)
    }
}
