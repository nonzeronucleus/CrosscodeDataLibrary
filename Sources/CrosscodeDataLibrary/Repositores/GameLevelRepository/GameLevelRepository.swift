import Foundation


public protocol GameLevelRepository: LevelRepository {
    func createPack() throws -> Pack

    func getPacks() throws -> [Pack]
}

typealias CoreDataGameLevelRepositoryImpl = CoreDataLevelRepository<GameLevelMO>


extension CoreDataGameLevelRepositoryImpl: GameLevelRepository {

//    func addPack() throws -> Pack {
//        let packMO = PackMO(context: context)
//    }
//    
    
    public func createPack() throws -> Pack{
        // 1. Get the current max number
        let fetchRequest: NSFetchRequest<PackMO> = PackMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        let maxNumberPack = try context.fetch(fetchRequest).first
        let nextNumber = (maxNumberPack?.number ?? 0) + 1
        
        // 2. Create new PackMO
        let newPack = PackMO(context: context)
        newPack.id = UUID()
        newPack.number = Int16(nextNumber)
        
        // 3. Save the context
        try context.save()
        
        return newPack.toPack()
    }
        
        
    
    func getPacks() throws -> [Pack] {
        let fetchRequest: NSFetchRequest<PackMO> = PackMO.fetchRequest()

        // Add sort descriptor for the `number` field (ascending)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "number", ascending: true)
        ]

        let results = try context.fetch(fetchRequest)

        return results.map { $0.toPack() }
    }
}



public enum LevelError: Error {
    case notFound
    case invalidData
    case coreDataError(Error)
}
