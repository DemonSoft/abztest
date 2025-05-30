//
//  UserFetch.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 15.05.2025.
//

import CoreData

class UserFetch : CoreDataEntityUpdate {
    enum Field: String {
        case id, registration
    }
    
    @Published var list = [User]()
    
    override func createFetchResultController<T>(_ context: NSManagedObjectContext) -> NSFetchedResultsController<T> where T : NSManagedObject {
        return UserEntity.createFetchResultController(delegate: self,
                                                         predicate: nil,
                                                      sortDescriptors: self.sortDescriptors,
                                                         context: context) as! NSFetchedResultsController<T>
    }

    var sortDescriptors:[NSSortDescriptor] {
        let sortNameDescriptor = NSSortDescriptor(key : Field.registration.rawValue,
                                            ascending : false)
        return [sortNameDescriptor]
    }

    override func fetched(list: [NSManagedObject]?) {
        guard let list = list as? [UserEntity] else { return }
        self.update(list)
    }

    override func changed<T>(list: [T]) where T : NSManagedObject {
        let list = list as? [UserEntity] ?? []
        self.update(list)
    }

    private func update(_ list: [UserEntity]) {
        let codable = list.compactMap({ $0.codable })
        main {
            self.list = codable
        }
    }
}
