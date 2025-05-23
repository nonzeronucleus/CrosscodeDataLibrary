import Foundation
import CoreData
import Factory

public class CoreDataLayoutRepository: LayoutRepository {
    private let context: NSManagedObjectContext
    
    // Injected via Factory
    public init(context: NSManagedObjectContext = Container.shared.managedObjectContext()) {
        self.context = context
    }
    
    public func create(level: LevelLayout) throws {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "LayoutMO", into: context) as! LayoutMO
        entity.populate(from: level)
        try CoreDataStack.shared.saveContext()
    }
    
    public func fetchLayout(id: UUID) async throws -> LevelLayout? {
        let fetchRequest: NSFetchRequest<LayoutMO> = LayoutMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                return nil
            }
            return results.first!.toLevel()
        } catch {
            context.rollback()
            throw LevelError.coreDataError(error)
        }
    }

    
    public func saveLevel(level: LevelLayout) throws {
        let fetchRequest: NSFetchRequest<LayoutMO> = LayoutMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", level.id as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            
            guard let existingLevel = results.first else {
                throw LevelError.notFound
            }
            
            existingLevel.populate(from: level)
            try CoreDataStack.shared.saveContext()
            
        } catch {
            context.rollback()
            throw LevelError.coreDataError(error)
        }
    }

    
    public func fetchAllLayouts() async throws -> [LevelLayout] {
        let fetchRequest: NSFetchRequest<LayoutMO> = LayoutMO.fetchRequest()
        
        // 2. Execute the fetch request
        let results = try context.fetch(fetchRequest)
        
        // 3. Convert each LayoutMO to Level using toLevel()
        return results.map { $0.toLevel() }
    }
    
    public func getHighestLevelNumber() async throws -> Int {
        let fetchRequest: NSFetchRequest<LayoutMO> = LayoutMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        let results = try context.fetch(fetchRequest)
        guard let firstResult = results.first else {
            return 0
        }
        return Int(firstResult.number)
    }

    public func deleteLayout(id: UUID) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            context.perform {
                do {
                    let fetchRequest: NSFetchRequest<LayoutMO> = LayoutMO.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    fetchRequest.fetchLimit = 1
                    
                    let results = try self.context.fetch(fetchRequest)
                    
                    guard let levelToDelete = results.first else {
                        continuation.resume(throwing: LevelError.notFound)
                        return
                    }
                    
                    self.context.delete(levelToDelete)
                    try CoreDataStack.shared.saveContext()
                    continuation.resume()
                } catch {
                    self.context.rollback()
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}
