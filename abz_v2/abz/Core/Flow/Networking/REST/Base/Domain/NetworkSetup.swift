//
//  NetworkSetup.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

import Foundation

class NetworkSetup {
    
    private var cfg:NetworkConfig

    init(_ cfg: NetworkConfig = RestNetworkProvider.instance.cfg) {
        self.cfg = cfg
    }

    static func builder(_ cmd: String) -> URL? {
        return NetworkSetup().urlBuilder(cmd)
    }
    
    func urlRequest(cmd: String, type:HttpType = .GET, params:Data? = nil) -> URLRequest? {
        guard let url               = self.urlBuilder(cmd) else { return nil}
        var request                 = URLRequest(url: url, timeoutInterval: self.cfg.timeout)
        request.allHTTPHeaderFields = self.headers
        request.httpMethod          = type.rawValue
        request.httpBody            = params
        request.cachePolicy         = .reloadIgnoringLocalCacheData
        return request
    }
    
    func uploadRequest(cmd: String, type:HttpType = .POST, params:Data? = nil, boundary: String) -> URLRequest? {
        guard let url               = self.urlBuilder(cmd) else { return nil}
        var request                 = URLRequest(url: url, timeoutInterval: self.cfg.timeout)
        request.allHTTPHeaderFields = self.multipartHeaders(boundary)
        request.httpMethod          = type.rawValue
        request.httpBody            = params
        request.cachePolicy         = .reloadIgnoringLocalCacheData
        return request
    }

    // MARK: - Private
    
    // NORMAL
    private var headers: [String: String] {
        var headers = ["Authorization": "Bearer \(self.cfg.bearer)",
                       "Accept": "application/json",
                       "Content-Type": "application/json",
                       "x-token": self.cfg.xToken]

        if let basicAuth = self.cfg.basicAuth {
            headers["Authorization"] = basicAuth
        }

        return headers
    }

    private func multipartHeaders(_ boundary: String) -> [String: String] {
        var headers             = self.headers
        headers["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        headers["Token"]        = self.cfg.bearer
        return headers
    }

    private func urlBuilder(_ cmd: String) -> URL? {
        let path = "\(self.cfg.base)\(cmd)"
        let link = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        return URL(string: link)
    }
}
