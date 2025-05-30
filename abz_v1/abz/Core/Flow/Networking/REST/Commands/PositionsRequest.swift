//
//  PositionsRequest.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 29.05.2025.
//

import Foundation

class PositionsRequest : NetworkBase {
    
    // MARK: - Types
    // MARK: - Variables
    override var command: String { return "positions" }

    private (set) var result : PositionList?
    
    override func receiveData(data:Data) async {
        self.result = await self.parse(data: data)
    }
}
