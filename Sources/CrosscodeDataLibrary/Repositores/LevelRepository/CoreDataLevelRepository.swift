import Foundation
import CoreData
import Factory


public protocol LevelRepository {
    func create(level: Layout) throws
    func saveLevel(level:Layout) throws
    
    func fetchAllLayouts() async throws -> [Layout]
    func fetchLayout(id: UUID) async throws -> Layout

    func getHighestLevelNumber() async throws -> Int
    
    func deleteLayout(id: UUID) async throws
    }


public class CoreDataLevelRepository: LevelRepository {
    
    private let context: NSManagedObjectContext
    
    // Injected via Factory
    public init(context: NSManagedObjectContext = Container.shared.managedObjectContext()) {
        self.context = context
    }

    public func create(level: Layout) throws {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "LevelMO", into: context) as! LevelMO
        entity.populate(from: level)
        try CoreDataStack.shared.saveContext()
    }
    
    public func fetchLayout(id: UUID) async throws -> Layout {
        let fetchRequest: NSFetchRequest<LevelMO> = LevelMO.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            return results.first!.toLevel()
        } catch {
            context.rollback()
            throw LevelError.coreDataError(error)
        }
    }

    
    public func saveLevel(level: Layout) throws {
        let fetchRequest: NSFetchRequest<LevelMO> = LevelMO.fetchRequest()
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

    
    public func fetchAllLayouts() async throws -> [Layout] {
        let fetchRequest: NSFetchRequest<LevelMO> = LevelMO.fetchRequest()
        
        // 2. Execute the fetch request
        let results = try context.fetch(fetchRequest)
        
        // 3. Convert each LevelMO to Level using toLevel()
        return results.map { $0.toLevel() }
    }
    
    public func getHighestLevelNumber() async throws -> Int {
        let fetchRequest: NSFetchRequest<LevelMO> = LevelMO.fetchRequest()
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
                    let fetchRequest: NSFetchRequest<LevelMO> = LevelMO.fetchRequest()
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
    
    // MARK: - Error Handling
    
}


public enum LevelError: Error {
    case notFound
    case invalidData
    case coreDataError(Error)
}
