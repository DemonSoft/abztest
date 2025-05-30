//
//  NSManagedObjectContext+Utils.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 10.05.2025.
//

import CoreData

protocol ICodableEntity {
    associatedtype CodableType
    var codable: CodableType { get }
}

extension NSManagedObjectContext {

    //Execute fetch request
    func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]? {
        let fetchedResult = try? self.fetch(request)
        return fetchedResult
    }

    func fetchObjects <T: NSManagedObject>(_ entityClass:T.Type, sortBy: [NSSortDescriptor]? = nil, fetchLimit:Int? = nil, predicate: NSPredicate? = nil) throws-> [T]? {
        guard let request: NSFetchRequest<T> = entityClass.fetchRequest() as? NSFetchRequest<T> else { return nil }
        if let fetchLimit = fetchLimit {
            request.fetchLimit = fetchLimit
        }
        request.predicate = predicate
        request.sortDescriptors = sortBy
        do {
            let fetchedResult = try self.fetch(request)
            return fetchedResult
        } catch (let error) {
            error.localizedDescription.logConsole()
        }
        return nil
    }

    //Helper method to fetch first object with given key value pair.
    func entity<T: NSManagedObject>(_ entityClass:T.Type, value:String) -> T? {
        let condition = "id = '\(value)'"
        let predicate = NSPredicate(format: condition)

        return try? self.fetchFirst(entityClass, sortBy: nil, predicate: predicate)
    }

    func fetchFirst<T: NSManagedObject>(_ entityClass:T.Type, key:String, value:String) -> T? {
        let condition = "\(key) = '\(value)'"
        let predicate = NSPredicate(format: condition)
        return try? self.fetchFirst(entityClass, sortBy: nil, predicate: predicate)
    }

    //Returns first object after executing fetchObjects method with given sort and predicates
    func fetchFirst <T: NSManagedObject>(_ entityClass:T.Type, sortBy: [NSSortDescriptor]? = nil, predicate: NSPredicate? = nil) throws-> T? {
        let result = try self.fetchObjects(entityClass, sortBy: sortBy, fetchLimit: 1, predicate: predicate)
        return result?.first
    }

    func fetchAll<T: NSManagedObject>(_ entityClass:T.Type) -> [T]? {
        return try? self.fetchObjects(entityClass)
    }
    
    @available(iOS 15.0.0, *)
    func get<E, R>(request: NSFetchRequest<E>) async throws -> [R] where E: NSManagedObject, E: ICodableEntity, R == E.CodableType {
            try await self.perform { [weak self] in
                try self?.fetch(request).compactMap { $0.codable } ?? []
            }
        }
}
