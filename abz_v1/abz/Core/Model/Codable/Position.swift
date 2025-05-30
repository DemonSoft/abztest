//
//  Position.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 29.05.2025.
//

import Foundation


struct PositionList: Codable {
    let positions : [Position]
}

struct Position: Codable {
    let id                     : Int
    let name                   : String
}

extension Position {
    static var placeholder: Position {
        return Position(id: 0, name: "")
    }
}
