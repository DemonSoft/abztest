//
//  Mistake.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

import Foundation

struct PayloadResponse<T:Decodable> : Decodable {
    let data: T?
    let mistake: Mistake?
}

struct Mistake: Decodable {
    let message: String
}

struct BusinessError: Decodable {
    let message: String
    let code: String?
    let caution: String?
}

extension PayloadResponse {
    
    func handleMistake() {
        if let message = self.mistake?.message {
            message.showError()
        }
    }

}
