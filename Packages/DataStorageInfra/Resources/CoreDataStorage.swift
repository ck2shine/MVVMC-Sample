//
//  CoreDataStorage.swift
//  
//
//  Created by Shine on 2022/3/13.
//


import CoreData

public enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

public final class CoreDataStorage {

    public final class func shared(storageName: String) -> CoreDataStorage {
        self.storageName = storageName
        return .singletonObject

    }

    public func getContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private static let singletonObject = CoreDataStorage()

    private static var storageName: String?

    private lazy var persistentContainer: NSPersistentContainer = {
        guard let name = CoreDataStorage.storageName else {
            fatalError("can not initialize coreData")
        }
        let container = NSPersistentContainer(name: name)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("CoreDataStorage can not be loaded , error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    public final func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("CoreDataStorage can not be saved ,  error \(error), \((error as NSError).userInfo)")
            }
        }
    }

    public final func saveEntity(entity: NSManagedObject) throws {
        try persistentContainer.viewContext.save()
    }

    public final func performMainContextTast(excuteBlock : @escaping () -> Void) {
        persistentContainer.viewContext.perform(excuteBlock)
    }

    public final func performBackgroundTask(  completeHandler handler : @escaping (NSManagedObjectContext) -> Void) {

        persistentContainer.performBackgroundTask(handler)
    }

}
