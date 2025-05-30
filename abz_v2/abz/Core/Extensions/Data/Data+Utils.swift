//
//  Data+Utils.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

import Foundation

extension Optional where Wrapped == Data
{
    var jsonString : String {
        guard let data = self else { return "" }
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return "\(json)"
        }
        return ""
    }
    
}

extension Data {
    func print() {
        Swift.print(self.toString())
    }
    
    func toString() -> String {
        return String(data: self, encoding: .utf8) ?? "DATA IS EMPTY"
    }
    
    func toJson() -> [String: Any]? {
        if let json = try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any] {
            return json
        }
        return nil
    }

}
