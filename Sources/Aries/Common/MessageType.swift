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

public enum MessageType: String {
    case connectionInvitation = "did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/connections/1.0/invitation"
    case connectionRequest = "did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/connections/1.0/request"
    case connectionResponse = "did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/connections/1.0/response"
    case credentialProposal = "did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/issue-credential/1.0/propose-credential"
    case credentialOffer = "did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/issue-credential/1.0/offer-credential"
    case credentialRequest = "did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/issue-credential/1.0/request-credential"
    case credentialIssue = "did:sov:BzCbsNYhMrjHiqZDTUASHg;spec/issue-credential/1.0/issue-credential"
}
