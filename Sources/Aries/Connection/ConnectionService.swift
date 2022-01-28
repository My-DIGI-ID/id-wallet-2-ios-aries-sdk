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

/// The service definition for exchanching DIDs with other agents.
///
/// Established connections are the foundation for further communication.
public protocol ConnectionService {
	// MARK: - Flow As Initiator
	/// Creates an invitation to initiate the DID exchange.
	///
	/// This function is the starting point as the inviter.
	///
	/// - Parameter wallet: The wallet that stores the connection.
	/// - Parameter configuration: Custom parameters for the invitation.
	/// - Returns: The sendable invitation message and the created record for the connection.
	func createInvitation(
		with wallet: Wallet,
		_ configuration: InvitationConfiguration
	) async throws -> (ConnectionInvitationMessage, ConnectionRecord)

	/// Revokes a created invitation and cancels the flow.
	///
	/// - Parameter connectionId: The identifier of the connection created with the invitation.
	/// - Parameter wallet: The wallet where the connection is stored.
	func revokeInvitation(
		for connectionId: String,
		in wallet: Wallet
	) async throws

	/// Updates the connection with the received request message.
	///
	/// - Parameter request: The received request message of the other party.
	/// - Parameter record: The record for the connection.
	/// - Parameter wallet: The wallet to update the record.
	/// - Returns: The connection identifier.
	func processRequest(
		_ request: ConnectionRequestMessage,
		with record: ConnectionRecord,
		in wallet: Wallet
	) async throws -> String

	/// Creates the response to complete an exchange flow.
	///
	/// This function is the finishing point as the inviter.
	///
	/// - Parameter id: The identifier of the connection.
	/// - Parameter wallet: The wallet containing the connection record.
	/// - Returns: The sendable response message and the updated record for the connection.
	func createResponse(
		for id: String,
		in wallet: Wallet
	) async throws -> (ConnectionResponseMessage, ConnectionRecord)

	// MARK: - Flow as Receiver
	/// Creates a request for DID exchange as response to an invitation.
	///
	/// This function is the starting point as the invitee.
	///
	/// - Parameter invitation: The invitation message to the DID exchange.
	/// - Parameter wallet: The wallet to store the connection.
	/// - Returns: The sendable request message and the created record for the connection.
	func createRequest(
		for invitation: ConnectionInvitationMessage,
		with wallet: Wallet
	) async throws -> (ConnectionRequestMessage, ConnectionRecord)

	/// Completes the DID exchange by updating the record with response of the inviter.
	///
	/// This function is the finishing point as the invitee.
	///
	/// - Parameter response: The response message of the inviter.
	/// - Parameter record: The record of the connection to be updated.
	/// - Parameter wallet: The wallet to update the record.
	/// - Returns: The connection identifier.
	func processResponse(
		_ response: ConnectionResponseMessage,
		with record: ConnectionRecord,
		in wallet: Wallet
	) async throws -> String
}
