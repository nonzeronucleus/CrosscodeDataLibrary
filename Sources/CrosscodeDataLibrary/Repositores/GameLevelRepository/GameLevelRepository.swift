import Foundation


public protocol GameLevelRepository: LevelRepository {
    func findOrCreateAvailablePack() throws -> Pack
    
    func createGameLevel(level: any Level, pack:Pack) throws
    func establishRelationships() throws
    func getHighestLevelNumber(for pack:Pack) async throws -> Int
    
    func fetchtGameLevels(packId: UUID) throws -> [GameLevel]
    func getPacks() throws -> [Pack]
}

typealias CoreDataGameLevelRepositoryImpl = CoreDataLevelRepository<GameLevelMO>


extension CoreDataGameLevelRepositoryImpl: GameLevelRepository {

    func getHighestLevelNumber(for pack:Pack) async throws -> Int {
        let request: NSFetchRequest<NSDictionary> = NSFetchRequest(entityName: "GameLevelMO")
        
        // Filter for this pack
        request.predicate = NSPredicate(format: "packId == %@", pack.id as CVarArg)
        
        // Set up max calculation
        let expression = NSExpression(forKeyPath: "number")
        let maxExpression = NSExpression(forFunction: "max:", arguments: [expression])
        
        let expressionDesc = NSExpressionDescription()
        expressionDesc.name = "maxLevelNumber"
        expressionDesc.expression = maxExpression
        expressionDesc.expressionResultType = .integer64AttributeType
        
        request.propertiesToFetch = [expressionDesc]
        request.resultType = .dictionaryResultType
        
//        if let result = try context.fetch(request).first {
//            debugPrint(result)
//        }

        
        guard let result = try context.fetch(request).first,
              let maxNumber = result["maxLevelNumber"] as? Int64 else {
            return 0
        }
        
        return Int(maxNumber)
    }
    
    
    func establishRelationships() throws {
        // 1. Fetch all GameLevelMOs
        let levelFetch: NSFetchRequest<GameLevelMO> = GameLevelMO.fetchRequest()
        let allLevels = try context.fetch(levelFetch)
        
        // 2. Fetch all PackMOs and create a UUID lookup dictionary
        let packFetch: NSFetchRequest<PackMO> = PackMO.fetchRequest()
        let allPacks = try context.fetch(packFetch)
        let packDict = Dictionary(uniqueKeysWithValues: allPacks.map { ($0.id, $0) })
        
        // 3. Process in batches to avoid memory issues
        var processedCount = 0
        let batchSize = 1000
        
        for level in allLevels {
            guard let packId = level.packId else { continue }
            
            if let pack = packDict[packId] {
                level.owningPack = pack  // This automatically updates the inverse relationship
            }
            
            processedCount += 1
            if processedCount % batchSize == 0 {
                try context.save()  // Periodic saves
                context.reset()     // Clear memory
            }
        }
        
        // 4. Final save
        try context.save()
    }
    
    
    func findOrCreateAvailablePack() throws -> Pack {
        return try findOrCreateAvailablePackMO().toPack()
    }

  
    func findOrCreateAvailablePackMO() throws -> PackMO {
        let maxLevelsInPack = 5

        let fetchRequest: NSFetchRequest<PackMO> = PackMO.fetchRequest()
        fetchRequest.propertiesToFetch = ["id", "number"]
        fetchRequest.relationshipKeyPathsForPrefetching = ["gameLevels"]
        
        let allPacks = try context.fetch(fetchRequest)
        
        if let availablePack = allPacks.sorted(by: { $0.number < $1.number })
                                       .first(where: { $0.gameLevels?.count ?? 0 < maxLevelsInPack }) {
            return availablePack
        }
        return try createPackMO()
    }
    
    func fetchtGameLevels(packId: UUID) throws -> [GameLevel] {
        let fetchRequest: NSFetchRequest = L.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "packId == %@", packId as CVarArg)
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "number", ascending: true)
        ]

        let results = try context.fetch(fetchRequest)
        
        return results.map { $0.toLevel() }
    }
    
    
    private func createPackMO() throws -> PackMO{
        // 1. Get the current max number
        let fetchRequest: NSFetchRequest<PackMO> = PackMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        let maxNumberPack = try context.fetch(fetchRequest).first
        let nextNumber = (maxNumberPack?.number ?? 0) + 1
        
        let newPack = PackMO(context: context)
        newPack.id = UUID()
        newPack.number = Int16(nextNumber)

        try context.save()
        
        return newPack
    }
    
    public func createGameLevel(level: any Level, pack:Pack) throws {
        let packMO = try getPackMO(packId: pack.id)
//        let packMO = try findOrCreateAvailablePackMO()
        
        let entity = GameLevelMO(context: context)
        
        entity.owningPack = packMO
        
        entity.populate(from: level)
        entity.packId = pack.id
        try CoreDataStack.shared.saveContext()
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
    
    func getPackMO(packId: UUID) throws -> PackMO? {
        let fetchRequest: NSFetchRequest<PackMO> = PackMO.fetchRequest()

        fetchRequest.predicate = NSPredicate(format: "id == %@", packId as CVarArg)
        
        fetchRequest.fetchLimit = 1
        
        let pack = try context.fetch(fetchRequest).first
        
        return pack
    }
}



public enum LevelError: Error {
    case notFound
    case invalidData
    case coreDataError(Error)
}
