import Foundation
import CoreData
import Factory


public protocol LevelRepository {
    func create(level: any Level) throws
    
    func save(level:any Level) throws
    
    func fetchAll() async throws -> [any Level]
    func fetch(id: UUID) async throws -> (any Level)?

    func getHighestLevelNumber() async throws -> Int
    
    func delete(id: UUID) async throws
}




class CoreDataLevelRepository<L: LevelMO>: LevelRepository {
    private let context: NSManagedObjectContext
    
    // Injected via Factory
    public init(context: NSManagedObjectContext = Container.shared.managedObjectContext()) {
        self.context = context
    }
    
    public func fetch(id: UUID) async throws -> (any Level)? {
        let fetchRequest: NSFetchRequest = L.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            guard let results = try context.fetch(fetchRequest) as? [L] else {
                fatalError("Failed to fetch LevelMO")
            }
            if results.isEmpty {
                return nil
            }
            return results.first!.toLevel()
        } catch {
            context.rollback()
            throw LevelError.coreDataError(error)
        }
    }

    
    public func save(level: any Level) throws {
        let fetchRequest: NSFetchRequest = L.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", level.id as CVarArg)
        fetchRequest.fetchLimit = 1

        do {
            guard let results = try context.fetch(fetchRequest) as? [L] else {
                fatalError("Failed to fetch LevelMO")
            }
            
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

    
    public func fetchAll() async throws -> [any Level] {
        let fetchRequest: NSFetchRequest = L.fetchRequest()
        
        

        guard let results = try context.fetch(fetchRequest) as? [L] else {
            fatalError("Failed to fetch LevelMO")
        }
        
        return results.map { $0.toLevel() }
    }
    
    public func getHighestLevelNumber() async throws -> Int {
        let fetchRequest: NSFetchRequest = L.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        guard let results = try context.fetch(fetchRequest) as? [L] else {
            fatalError("Failed to fetch LevelMO")
        }
        
        guard let firstResult:L = results.first else {
            return 0
        }
        return Int(firstResult.number)
    }

    public func delete(id: UUID) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            context.perform {
                do {
                    let fetchRequest: NSFetchRequest = L.fetchRequest()
                    fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                    fetchRequest.fetchLimit = 1
                    
                    guard let results = try self.context.fetch(fetchRequest) as? [L] else {
                        fatalError("Failed to fetch LevelMO")
                    }
                    
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
    
    public func create(level: any Level) throws {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "\(L.self)", into: context) as! LevelMO
        entity.populate(from: level)
        try CoreDataStack.shared.saveContext()
    }
}



