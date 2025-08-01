import Foundation
import CoreData
//
public class CoreDataStack {
    nonisolated(unsafe) public static let shared = CoreDataStack()

    public let persistentContainer: NSPersistentContainer
    private let debug = false

    private init() {
        let bundle = Bundle.module
        guard let modelURL = bundle.url(forResource: "MyModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model")
        }

        persistentContainer = NSPersistentContainer(name: "MyModel", managedObjectModel: model)
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unresolved error \(error)")
            }
            if self.debug {
                self.printLocation(description: description)
            }
        }
//        printLocation(description: persistentContainer.persistentStoreDescriptions.first!)
    }

    public var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    public func saveContext() throws {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    func printLocation(description: NSPersistentStoreDescription) {
        print("Core Data DB Location:", description.url?.absoluteString ?? "Unknown location")
    }
}
