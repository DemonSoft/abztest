//
//  RestNetworkProvider.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

import Foundation

typealias RestNetwork = RestNetworkProvider

class RestNetworkProvider {
    
    static let instance = RestNetworkProvider()
    private (set) var cfg = NetworkConfig()

    static func update(_ cfg: NetworkConfig) {
        self.instance.cfg = cfg
    }
    
    static func start() {
        let endpoint = RestEndpoint(scheme: "https",
                                    host: "frontend-test-assignment-api.abz.agency",
                                    port: "443",
                                    version: "v1")
        let cfg = NetworkConfig(base: endpoint.base, bearer: Settings.bearer)
        RestNetworkProvider.update(cfg)
        
        "BEARER: \(Settings.bearer)".logConsole()
    }
    
    static func bearerSet(_ bearer: String) {
        let cfg = self.instance.cfg
        let bearerCfg = NetworkConfig(base: cfg.base,
                                      xToken: cfg.xToken,
                                      bearer: bearer,
                                      basicAuth: cfg.basicAuth,
                                      timeout: cfg.timeout)
        Self.update(bearerCfg)
    }
}
