//
//  TokenRequest.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 29.05.2025.
//

import Foundation

class TokenRequest : NetworkBase {
    
    // MARK: - Types
    struct Params : Encodable {}
    struct Result : Codable {
        let token: String
    }
    // MARK: - Variables
    override var command: String { return "token" }
    private (set) var result : Result?
    
    func adjust() -> Self {
        return self.adjust(.POST, Params())
    }

    override func receiveData(data:Data) async {
        self.result = await self.parse(data: data)
        if let result = self.result {
            Settings.bearer = result.token
            RestNetworkProvider.bearerSet(result.token)
        }
    }
}

