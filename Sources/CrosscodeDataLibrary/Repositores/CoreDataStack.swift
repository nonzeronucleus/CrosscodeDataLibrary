import Foundation
import CoreData
//
//public class CoreDataStack {
//    public static let shared = CoreDataStack()
//
//    public let persistentContainer: NSPersistentContainer
//
//    private init() {
//        let bundle = Bundle.module
//        guard let modelURL = bundle.url(forResource: "MyModel", withExtension: "momd"),
//              let model = NSManagedObjectModel(contentsOf: modelURL) else {
//            fatalError("Failed to load Core Data model")
//        }
//
//        persistentContainer = NSPersistentContainer(name: "MyModel", managedObjectModel: model)
//        persistentContainer.loadPersistentStores { _, error in
//            if let error = error {
//                fatalError("Unresolved error \(error)")
//            }
//        }
//    }
//
//    public var context: NSManagedObjectContext {
//        persistentContainer.viewContext
//    }
//
//    public func saveContext() throws {
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            try context.save()
//        }
//    }
//}


public class CoreDataStack {
    public static let shared = CoreDataStack()
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let modelName = "MyModel"
        
        // First try the module bundle (for SwiftPM)
        guard let modelURL = Bundle.module.url(forResource: modelName, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model")
        }
        
        let container = NSPersistentContainer(name: modelName, managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public func saveContext() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
