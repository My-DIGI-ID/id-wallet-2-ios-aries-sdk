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

/// Extension for generating DID documents for the participants of the connection.
extension ConnectionRecord {
    private static let defaultType = "Ed25519VerificationKey2018"
    
    public func myDocument(for record: ProvisioningRecord) -> Document {
        let did = myDid!
        let verkey = myVerkey!
        
        var document = Document(id: did)
        document.keys = [
            DocumentKey(
                id: "\(did)#keys-1",
                type: Self.defaultType,
                controller: [did],
                key: verkey
            )
        ]
        
        if let endpoint = record.endpoint, !endpoint.verkeys.isEmpty, !endpoint.uri.isEmpty {
            var service = DocumentService(
                id: "\(did);indy",
                endpoint: endpoint.uri
            )
            service.recipientKeys = [verkey]
            service.routingKeys = record.endpoint?.verkeys
            document.services = [service]
        }
        
        return document
    }
    
    public func theirDocument() -> Document {
        let did = theirDid!
        let verkey = theirVerkey!
        
        var document = Document(id: did)
        document.keys = [
            DocumentKey(
                id: "\(did)#keys-1",
                type: Self.defaultType,
                controller: [did],
                key: verkey
            )
        ]
        
        if let endpoint = endpoint, !endpoint.uri.isEmpty {
            var service = DocumentService(
                id: "\(did);indy",
                endpoint: endpoint.uri
            )
            service.recipientKeys = [verkey]
            service.routingKeys = endpoint.verkeys
            document.services = [service]
        }
        
        return document
	}
}
