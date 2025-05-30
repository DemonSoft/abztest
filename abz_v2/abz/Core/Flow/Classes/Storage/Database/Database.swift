//
//  Database.swift
//  abz.agency
//
//  Created by Dmitriy Soloshenko on 10.05.2025.
//

import CoreData
import SwiftUI
import AsyncAlgorithms

protocol IDatabase : AnyObject {
}

typealias DB = Database
typealias Commit = (_ context:NSManagedObjectContext) -> Void
typealias Failure = (_ context:NSManagedObjectContext) -> Void

/*
 This class need to replace path of database for maintance it.
 */

class DSPersistentContainer : NSPersistentContainer {
    override class func defaultDirectoryURL() -> URL {
        return super.defaultDirectoryURL().appendingPathComponent(DB.databaseName)
    }
}

class Database : IDatabase {
    
    typealias Payload = (_ context:NSManagedObjectContext) -> Void

    // MARK: - Variables
    
    // MARK: - Outlets
    
    // MARK: - Public Properties
    class var pathDirectory : URL {
        return DSPersistentContainer.defaultDirectoryURL()
    }
    class var path : URL {
        return self.pathDirectory.appendingPathComponent("\(Self.databaseName).sqlite")
    }

    class var databaseName : String {
        return "db"
    }
    
    static func channel(_ message:String) {
        Task {
            await self.instance.channel.send(message)
        }
    }
    // MARK: - Private Properties
    private let debounceTime: Double = 1.0
    private let channel = AsyncChannel<String>()
    private var task: Task<Void, Never>?

    private lazy  var mergedModel : NSManagedObjectModel = {
        let bundle = Bundle(for: type(of: self))
        guard let model = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError("No models found!")
        }
        return model
    }()
    
    private lazy var container : NSPersistentContainer = {
        let container = DSPersistentContainer(name: Self.databaseName, managedObjectModel: self.mergedModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                
//                "Can't find mapping model for migration".logConsole()
                DB.channel("Can't find mapping model for migration")
                DatabaseVersionManager.start()
//                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    // MARK: - Constructors
    
    
    // MARK: - Singletone Implementation
    static private let instance  = Database()
    
    static var mainContext : NSManagedObjectContext {
        return self.instance.container.viewContext
    }

    static var backgroundContext : NSManagedObjectContext {
        return self.instance.backgroundContext
    }

    private init() {
        DatabaseVersionManager.start()
        self.create()
        let msg = "Database started...\n\(DB.path.path)\n"
        msg.logConsole()
        
        self.task = Task { [weak self] in
            guard let self = self else { return }
            for await event in self.channel.debounce(for: .seconds(self.debounceTime)) {
                "DB: \(event)".logConsole()
            }
        }
        DB.channel(msg)

    }
    
    deinit {
        self.channel.finish()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    // MARK: - Methods of class
    class func start() {
        self.instance.start()
    }

    
    class func transact(_ sender:Any?=nil, _ task:@escaping Payload, _ commit: Commit? = nil, _ failure: Failure? = nil) async {
        let context = self.instance.backgroundContext

        await withCheckedContinuation { continuation in
            context.perform {
                task(context)
                context.save(sender, commit, failure)
                continuation.resume()
            }
        }
    }
    

    
    class func readOnly(_ worktask:@escaping Payload) {
        let context = self.instance.container.viewContext
        context.perform {
            worktask(context)
        }
    }

    class func saveOnly(_ sender:Any?=nil, _ worktask:@escaping Payload) {
        let context = self.instance.container.viewContext
        worktask(context)
        context.save(sender)
    }
     
    
    class func maintanance() {
        
        let context = self.instance.container.viewContext
        context.save(self, { _ in
            //"DB WAS CREATED".logConsole()
            DB.channel("DB WAS CREATED")
        }, { _ in
            DB.channel("DB WAS FAILED")
//            "DB WAS FAILED".logConsole()
        })
    }
    
    // MARK: - Methods of instance
    func start() {
        DB.maintanance()
    }
    
    // MARK: - Core Data stack
    class func clean( _ worktask:@escaping Payload, callback: (()-> Void)? = nil) async
    {
        await self.transact(self) { (context) in
            worktask(context)
            "Database cleared".logConsole()
        } _: { (_) in
            callback?()
        }
    }
    

    // MARK: - Core Data Saving support
    private func create() {
        let context = self.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
