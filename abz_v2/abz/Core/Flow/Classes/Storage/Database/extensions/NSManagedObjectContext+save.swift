//
//  NSManagedObjectContext+save.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 12.05.2025.
//

import CoreData

extension NSManagedObjectContext {
    func save( _ sender:Any?=nil, _ commit: Commit? = nil, _ failure: Failure? = nil) {
        let start = Date()
        do {
            if self.hasChanges {
                try self.save()
                let message = "WAS SAVED SUCCEEDED! \(self.typeName(sender ?? self)) Duration: \(-start.timeIntervalSinceNow)"
                DB.channel(message)

            } else {
                let message = "Context is empty for \(self.typeName(sender ?? self))"
                DB.channel(message)
            }
            commit?(self)
        } catch (let e) {
            let message = "‼️ FAILURE TO SAVED CONTEXT: \(e.localizedDescription)\n\(self) FOR \(self.typeName(sender ?? self)) Duration: \(-start.timeIntervalSinceNow)"
            DB.channel(message)
            failure?(self)
        }
    }
    
    // MARK: - Private methods
    private func typeName(_ some: Any) -> String {
        if let s = self.registeredObjects.first.self {
            return "\(type(of: s))"
        }
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }
}
