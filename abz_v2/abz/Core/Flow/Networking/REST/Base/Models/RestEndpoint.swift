//
//  RestEndpoint.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

import Foundation

struct RestEndpoint {
    let scheme     :String
    let host       :String
    let port       :String
    let version    :String

    var base : String  {
        return "\(self.scheme)://\(self.host):\(self.port)/api/\(self.version)/"
    }
    
    init(scheme: String, host: String, port: String, version: String) {
        self.scheme  = scheme
        self.host    = host
        self.port    = port
        self.version = version
    }
}
