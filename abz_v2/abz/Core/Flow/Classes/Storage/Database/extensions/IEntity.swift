//
//  IEntity.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 10.05.2025.
//

import Foundation
import CoreData

protocol IEntity {
}

extension NSManagedObject {
    enum Field:String {
        case ident = "id"
    }
}

extension IEntity where Self : NSManagedObject
{
    static func asyncFetch(callback:((_ list:[NSFetchRequestResult]?)->Void)?, filterCondition:String? = nil, fetchBatchSize: Int = 0, sortDescriptors:[NSSortDescriptor]? = nil, context:NSManagedObjectContext = DB.backgroundContext) -> NSAsynchronousFetchRequest<NSFetchRequestResult> {
        let fetchRequest             = self.fetchRequest()
        fetchRequest.predicate       = nil
        
        fetchRequest.sortDescriptors = sortDescriptors ?? [NSSortDescriptor(key : Field.ident.rawValue, ascending : true)]
        
        if let condition = filterCondition {
            fetchRequest.predicate = NSPredicate(format : condition)
        }
        
        if fetchBatchSize > 0 {
            fetchRequest.fetchBatchSize = fetchBatchSize
        }
        
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { result in

            guard let list = result.finalResult else {
            return
          }
            
            callback?(list)
        }
        return asyncFetchRequest
    }

    static func createFetchResultController(delegate:NSFetchedResultsControllerDelegate,
                                            predicate:NSPredicate? = nil,
                                            fetchBatchSize: Int? = nil,
                                            sortDescriptors:[NSSortDescriptor] = Self.defaultSortDescriptors,
                                            context:NSManagedObjectContext = DB.backgroundContext) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest             = Self.fetchRequest()
        fetchRequest.predicate       = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        if let size = fetchBatchSize {
            fetchRequest.fetchBatchSize = size
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        
        fetchedResultsController.delegate = delegate
        return fetchedResultsController
    }

    static func createFetchResultController(delegate:NSFetchedResultsControllerDelegate,
                                            filterCondition:String? = nil,
                                            fetchBatchSize: Int? = nil,
                                            sortDescriptors:[NSSortDescriptor] = Self.defaultSortDescriptors,
                                            context:NSManagedObjectContext = DB.backgroundContext) -> NSFetchedResultsController<NSFetchRequestResult> {
        let predicate       = filterCondition != nil ?
                                        NSPredicate(format : filterCondition!) : nil
        return Self.createFetchResultController(
            delegate: delegate,
            predicate: predicate,
            sortDescriptors: sortDescriptors,
            context: context)
    }

    static func createFetchResultWithSectionsController(sectionName: String?,
                                                        sortDescriptors:[NSSortDescriptor],
                                                        filterCondition:String?,
                                                        delegate:NSFetchedResultsControllerDelegate?,
                                                        context:NSManagedObjectContext = DB.backgroundContext) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest             = self.fetchRequest()
        fetchRequest.fetchBatchSize  = 20

       fetchRequest.sortDescriptors = sortDescriptors

        let predicate                = filterCondition != nil ? NSPredicate(format : filterCondition!) : nil
        fetchRequest.predicate       = predicate
        fetchRequest.sortDescriptors = sortDescriptors

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: sectionName,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = delegate
        return fetchedResultsController
    }

    static var defaultSortDescriptors : [NSSortDescriptor] {
        let sortNameDescriptor       = NSSortDescriptor(key : Field.ident.rawValue, ascending : true)
        return [sortNameDescriptor]
    }

    static var all : [Self] {
        return self.fetchAllData(context:DB.mainContext)
    }

    static var allBackground : [Self] {
        return self.fetchAllData(context:DB.backgroundContext)
    }

    static func fetchAllData(context:NSManagedObjectContext) -> [Self]
    {
        if let array = context.fetchAll(Self.self) {
            return array
        }

        return [Self]()
    }

    static func entity(ident:String, context:NSManagedObjectContext) -> Self? {
        return context.fetchFirst(Self.self, key: Field.ident.rawValue, value: ident)
    }

    static func exist(ident:String, context:NSManagedObjectContext) -> Bool {
        return self.entity(ident:ident, context:context) != nil
    }


    static func createIfNotExist(ident:String, context:NSManagedObjectContext) -> Self?
    {
        if let entity = self.entity(ident:ident, context:context) {
            return entity
        }

        let entity = Self(context: context)
        entity.setValue(ident, forKey:  Field.ident.rawValue)
        return entity
    }
    
    static func parse(data:NSDictionary) -> Self? {
        return nil
    }
    
    static func cleanAll(_ context:NSManagedObjectContext) {
        let items = self.fetchAllData(context: context)
        for item in items {
            context.delete(item)
        }
        print("\n====================")
        print("ALL \(self) REMOVED!")
        print("====================\n")
    }
    
    static func myPrint(_ context:NSManagedObjectContext) {
        "\(self.fetchAllData(context: context))".logConsole()
    }
    
    static func removeAll(_ list:NSSet?, context:NSManagedObjectContext) {
        guard let array = list?.allObjects as? [NSManagedObject] else {
            return
        }
        
        for item in array {
            context.delete(item)
        }
    }
    
    func delete(_ context:NSManagedObjectContext) {
        context.delete(self)
    }

}
