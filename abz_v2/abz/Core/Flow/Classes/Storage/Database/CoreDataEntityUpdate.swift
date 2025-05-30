//
//  CoreDataEntityUpdate.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 10.05.2025.
//

import CoreData
import AsyncAlgorithms

class CoreDataEntityUpdate: NSObject, ObservableObject {
    // MARK: - Types
    
    typealias FetchInfo = (event: EventType, oldIndex: IndexPath?, newIndex: IndexPath?, controller: NSFetchedResultsController<NSManagedObject>)
    
    // MARK: - Enums
    
    enum EventType {
        case start
        case finish
        case update
    }
    
    // MARK: - Private Properties
    private var startedFetch = Date()
    private let channel = AsyncChannel<[NSManagedObject]>()
    private var task: Task<Void, Never>?
    
    // MARK: - Public Properties
    private (set) var data: FetchInfo? {
        didSet {
            main { [weak self] in
                self?.changed()
            }
            
            Task(priority: .background) { [weak self] in
                guard let self = self else { return }
                await self.channel.send(self.data?.controller.fetchedObjects ?? [])
            }
        }
    }
    
    var duration: String {
        return String(format: "%.6f", -self.startedFetch.timeIntervalSinceNow)
    }
    
    override init() {
        super.init()
        self.task = Task(priority: .background) { [weak self] in
            await self?.subscribe()
        }

        self.fetch()
    }
    
    deinit {
        "FETCHER \(self) DEINIT".logConsole()
        self.channel.finish()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    func createFetchResultController<T:NSManagedObject>(_ context:NSManagedObjectContext) -> NSFetchedResultsController<T>? {
        return nil
    }
    
    func fetch() {
        let context = DB.backgroundContext
        let data = self.getFetch(context)
        self.fetched(list: data?.controller.fetchedObjects)
        self.data = data
    }
    
    func resetDuration() {
        self.startedFetch = Date()
    }

    // Pure virtual method
    func changed() {}
    func changed<T: NSManagedObject>(list: [T]) {}
    func fetched(list: [NSManagedObject]?) {}

    // MARK: - Private
    private func subscribe() async {
        for await list in self.channel.removeDuplicates() {
            self.changed(list: list)
        }
    }
    
    private func getFetch(_ context:NSManagedObjectContext) -> FetchInfo? {
        
        guard let controller = self.createFetchResultController(context) else {
            return nil
        }
        do {
            try controller.performFetch()
        }
        catch (let error) {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        return FetchInfo(event: .start, oldIndex: nil, newIndex: nil, controller: controller)
    }
}

extension CoreDataEntityUpdate: NSFetchedResultsControllerDelegate
{
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
              didChange anObject: Any,
                    at indexPath: IndexPath?,
                        for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        self.data = FetchInfo(event: .update,
                           oldIndex: indexPath,
                           newIndex: newIndexPath,
                         controller: controller as! NSFetchedResultsController<NSManagedObject>)
    }
    
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
//
//    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange sectionInfo: NSFetchedResultsSectionInfo,
                    atSectionIndex sectionIndex: Int,
                    for type: NSFetchedResultsChangeType) {
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.data = FetchInfo(event: .finish,
                           oldIndex: nil,
                           newIndex: nil,
                         controller: controller as! NSFetchedResultsController<NSManagedObject>)
    }

}
