//
//  Link.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 29.05.2025.
//

import Foundation

struct Links: Codable {
    let next_url: String?
    let prev_url: String?
}

extension Links {
    var nextUrl : URL? {
        return URL(string: self.next_url ?? "")
    }
    var prevtUrl : URL? {
        return URL(string: self.prev_url ?? "")
    }
}
