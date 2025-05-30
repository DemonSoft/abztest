//
//  SendUserRequest.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 29.05.2025.
//

import Foundation

class SendUserRequest : NetworkBase {
    
    // MARK: - Types
    struct Params : Encodable {
        let name: String
        let email: String
        let phone: String
        let position_id: Int32
        let photo: String
    }
    
    struct Result : Codable {
        let success: Bool
        let user_id: Int
        let message: String
    }

    // MARK: - Variables
    override var command: String { return "users" }

    private (set) var result : Result?
    private var user  = User.placeholder
    
    override func receiveData(data:Data) async {
        self.result = await self.parse(data: data)
        
        if self.result == nil {
            self.metadata.callback?(self)
        }
    }
    
    override func parse<T:Decodable>(data: Data) async -> T? {
        return await self.finalParse(data)
    }

}
