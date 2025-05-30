//
//  INetworkBase.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 08.05.2025.
//

import Foundation

typealias NetworkCallback = (_ req: INetworkBase) -> Void

protocol INetworkBase {
    var metadata: NetworkMetadata { get }
    var resp: NetworkBase.NetResponse? { get }
    var fullLink: String { get }
    var succeeded: Bool{ get }
    var command : String { get }
    
    func adjust<T: Encodable>(_ type:HttpType, _ params:T?) -> Self
    func execute(_ callback:NetworkCallback?)
}
