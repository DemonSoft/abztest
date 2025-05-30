//
//  UserPage.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 29.05.2025.
//

import Foundation

struct UserPage: Codable {
    let success     : Bool
    let page        : Int
    let total_pages : Int
    let total_users : Int
    let count       : Int
    let links       : Links
    let users       : [User]
}


