import Foundation
import CoreData

public class CoreDataLevelRepository {
    private let context = CoreDataStack.shared.context

    public init() {}

    public func create(level: Level) throws {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "LevelMO", into: context) as! LevelMO
        entity.populate(from: level)
        try CoreDataStack.shared.saveContext()
    }

    public func fetchAll() throws -> [Level] {
        let fetchRequest: NSFetchRequest<LevelMO> = LevelMO.fetchRequest()
        
        // 2. Execute the fetch request
        let results = try context.fetch(fetchRequest)
        
        // 3. Convert each LevelMO to Level using toLevel()
        return results.map { $0.toLevel() }
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LevelMO")
//        let results = try context.fetch(fetchRequest)
//        return results.map {
//            Level(...)
//        }
    }

//    public func update(person: PersonModel) throws {
//        guard let id = person.id else { return }
//        let object = try context.existingObject(with: id)
//        object.setValue(person.name, forKey: "name")
//        object.setValue(person.age, forKey: "age")
//        try CoreDataStack.shared.saveContext()
//    }
//
//    public func delete(person: PersonModel) throws {
//        guard let id = person.id else { return }
//        let object = try context.existingObject(with: id)
//        context.delete(object)
//        try CoreDataStack.shared.saveContext()
//    }
}
