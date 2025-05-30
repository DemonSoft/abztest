//
//  NetworkConfig.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

import Foundation

struct NetworkConfig {
    let base      : String
    let xToken    : String
    let bearer    : String
    let basicAuth : String?
    let timeout   : Double
    
    init(base: String = "localhost",
         xToken: String = "",
         bearer: String = "",
         basicAuth: String? = nil,
         timeout: Double = 30) {
        self.base      = base
        self.xToken    = xToken
        self.bearer    = bearer
        self.basicAuth = basicAuth
        self.timeout   = timeout
    }
}
