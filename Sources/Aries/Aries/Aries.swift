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

/// Entry point to the Aries library which provides access to all the service instances.
///
/// It is possible to replace them with custom implementations.
/// Mind that the default services are built to work together, but since these are all abstractions,
/// there should not be any implicit dependencies on underlying implementations.
///
public enum Aries {
    public static var wallet: WalletService = DefaultWalletService()
    public static var record: RecordService = DefaultRecordService()
	public static var message: MessageService = DefaultMessageService()
	public static var crypto: CryptoService = DefaultCryptoService()
	public static var provisioning: ProvisioningService = DefaultProvisioningService(
		recordService: record
	)
	public static var connection: ConnectionService = DefaultConnectionService(
		recordService: record,
		provisioningService: provisioning
	)
}
