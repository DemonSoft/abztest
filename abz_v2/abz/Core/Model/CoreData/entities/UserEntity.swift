//
//  UserEntity.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 10.05.2025.
//

import Foundation
import CoreData

extension UserEntity : IEntity {
    
    static func keep(_ users: [User]) async {
       await DB.transact {context in
           
           for user in users {
               guard let entity = UserEntity.createIfNotExist(ident: "\(user.id)", context: context) else { continue }
               
               entity.name         = user.name
               entity.email        = user.email
               entity.phone        = user.phone
               entity.position     = user.position
               entity.position_id  = user.position_id
               entity.photo        = user.photo
               entity.registration = user.registration_timestamp
           }
        }
    }

    var codable: User {
        return User(id: Int(self.id ?? "") ?? 0,
                    name: self.name ?? "",
                    email: self.email ?? "",
                    phone: self.phone ?? "",
                    position: self.position ?? "",
                    position_id: self.position_id,
                    registration_timestamp: self.registration,
                    photo: self.photo ?? "")
    }
    
}

