//
//  Database+logout.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 22.05.2025.
//

import Foundation

extension Database {
    static func logoutClear() {
        Task {
            await Self.transact { context in
                UserEntity.cleanAll(context)
            }
        }
    }
}
