//
//  Profile.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 09.05.2025.
//

import Foundation

struct User: Codable {
    let id                     : Int
    let name                   : String
    let email                  : String
    let phone                  : String
    let position               : String
    let position_id            : Int32
    let registration_timestamp : Int64
    let photo                  : String
}

extension User {
    static var placeholder: User {
        return User(id: 0, name: "", email: "", phone: "", position: "", position_id: 0, registration_timestamp: 0, photo: "")
    }
    
    var url : URL? {
        return URL(string: self.photo)
    }
}
