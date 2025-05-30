//
//  NetworkMetadata.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

import Foundation

struct NetworkMetadata {
    var respondHeaders = [AnyHashable : Any]()
    var httpType       = HttpType.GET
    var params: Data?
    var encoded: Encodable?
    
    var setup           = NetworkSetup()
    var startedRequest  = Date()
    var succeeded       = false
    var isTest          = false
    var callback:  NetworkCallback?
}
