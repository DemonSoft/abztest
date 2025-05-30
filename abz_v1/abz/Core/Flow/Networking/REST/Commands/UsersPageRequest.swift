//
//  UsersPageRequest.swift
//  abz
//
//  Created by Dmitriy Soloshenko on 29.05.2025.
//

import Foundation

class UsersPageRequest : NetworkBase {
    
    // MARK: - Types
    // MARK: - Variables
    override var command: String { return "users?page=\(self.page)&count=\(self.count)" }

    private (set) var result : UserPage?
    private var page  = 1
    private var count = 100
    
    func adjust(page: Int, count: Int = 100) -> Self {
        self.page = page
        self.count = count
        return self
    }

    override func receiveData(data:Data) async {
        self.result = await self.parse(data: data)
    }
}

