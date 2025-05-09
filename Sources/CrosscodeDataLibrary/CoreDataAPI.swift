import Foundation
import CoreData

public struct PersonModel {
    public var id: NSManagedObjectID?
    public var name: String
    public var age: Int16

    public init(id: NSManagedObjectID? = nil, name: String, age: Int16) {
        self.id = id
        self.name = name
        self.age = age
    }
}

public class PersonManager {
    private let context = CoreDataStack.shared.context

    public init() {}

    public func create(person: PersonModel) throws {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context)
        entity.setValue(person.name, forKey: "name")
        entity.setValue(person.age, forKey: "age")
        try CoreDataStack.shared.saveContext()
    }

    public func fetchAll() throws -> [PersonModel] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        let results = try context.fetch(fetchRequest)
        return results.map {
            PersonModel(id: $0.objectID,
                        name: $0.value(forKey: "name") as? String ?? "",
                        age: $0.value(forKey: "age") as? Int16 ?? 0)
        }
    }

    public func update(person: PersonModel) throws {
        guard let id = person.id else { return }
        let object = try context.existingObject(with: id)
        object.setValue(person.name, forKey: "name")
        object.setValue(person.age, forKey: "age")
        try CoreDataStack.shared.saveContext()
    }

    public func delete(person: PersonModel) throws {
        guard let id = person.id else { return }
        let object = try context.existingObject(with: id)
        context.delete(object)
        try CoreDataStack.shared.saveContext()
    }
}
