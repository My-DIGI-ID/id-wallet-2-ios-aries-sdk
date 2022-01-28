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

/// Basic container for messages that get sent between agents.
///
/// When coding custom message types, id and type must be prefixed with @
/// as these are reserved names.
///
/// Todo: Add decorators, encoded decorators need to prefix their name with ~.
public protocol Message: Codable {
	var id: String { get }
	var type: String { get }
}
