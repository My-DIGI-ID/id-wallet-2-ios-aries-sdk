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

/// The abstraction over all records.
///
/// If you want to implement your own type of record, you need decide how the specific properties should be stored.
/// There are 3 ways to store it:
/// - Codable: 		The result of encoding / decoding is stored as is and can not be queried.
/// - Tag, unencrypted: 	Data in the tags dictionary which key is prefixed with `~` gets stored separately and
///                 unencrypted. These properties can be fully addressed in query filters.
/// - Tag, encryptied:	Data in the tags dictionary without prefixed key gets also stored separately but unencrypted.
/// 				These properties can be only addressed in query filters, when used with (un)equality operators.
public protocol Record: Codable {
	static var type: String { get }
    /// The identifier of the record
	var id: String { get }
    /// The additional tags.
	var tags: [String: String] { get set }
}
