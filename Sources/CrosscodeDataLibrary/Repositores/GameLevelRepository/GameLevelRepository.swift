import Foundation


public protocol GameLevelRepository: LevelRepository {
   func createGameLevel(level: any Level) throws

    
//    func getNumLevelsInPack(packId: UUID) throws -> Int
    func establishRelationships() throws

//    func findOrCreateAvailablePack() throws /*-> PackMO*/

    func fetchtGameLevels(packId: UUID) throws -> [GameLevel]
//    func createPack() throws -> Pack

    func getPacks() throws -> [Pack]
}

typealias CoreDataGameLevelRepositoryImpl = CoreDataLevelRepository<GameLevelMO>


extension CoreDataGameLevelRepositoryImpl: GameLevelRepository {
//    func getNumLevelsInPack(packId: UUID) throws -> Int {
//        let fetchRequest: NSFetchRequest = L.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "packId == %@", packId as CVarArg)
//
//        let results = try context.fetch(fetchRequest)
//        
//        return results.count
//    }
    
    
//    func findOrCreateAvailablePack(in context: NSManagedObjectContext) throws -> PackMO {
//        // 1. Fetch all packs with their level counts
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PackMO")
//        fetchRequest.propertiesToFetch = ["id", "number"]
//        fetchRequest.resultType = .dictionaryResultType
//        
//        // Create an expression to count levels per pack
//        let expressionDesc = NSExpressionDescription()
//        expressionDesc.name = "levelCount"
//        expressionDesc.expression = NSExpression(
//            forFunction: "count:",
//            arguments: [NSExpression(forKeyPath: "gameLevels")] // Assuming your relationship is named "gameLevels"
//        )
//        expressionDesc.expressionResultType = .integer32AttributeType
//        
//        fetchRequest.propertiesToGroupBy = ["id", "number"]
//        fetchRequest.propertiesToFetch = ["id", "number", expressionDesc]
//        
//        // 2. Execute fetch and find first pack with <25 levels
//        if let results = try context.fetch(fetchRequest) as? [[String: Any]] {
//            for result in results.sorted(by: { ($0["number"] as? Int16 ?? 0) < ($1["number"] as? Int16 ?? 0) }) {
//                if let levelCount = result["levelCount"] as? Int, levelCount < 25 {
//                    let packId = result["id"] as! UUID
//                    let pack = try context.existingObject(with: packId) as! PackMO
//                    return pack
//                }
//            }
//        }
//        
//        // 3. If no available pack found, create a new one
//        let newPack = PackMO(context: context)
//        newPack.id = UUID()
//        newPack.number = try PackMO.getNextPackNumber(in: context)
//        try context.save()
//        
//        return newPack
//    }
//
    
    
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
    
  
    func findOrCreateAvailablePack() throws -> PackMO {
        // 1. Create fetch request with count
        let fetchRequest: NSFetchRequest<PackMO> = PackMO.fetchRequest()
        fetchRequest.propertiesToFetch = ["id", "number"]
        fetchRequest.relationshipKeyPathsForPrefetching = ["gameLevels"]
        
        // 2. Fetch all packs with their levels
        let allPacks = try context.fetch(fetchRequest)
        
        // 3. Find first pack with <25 levels (sorted by pack number)
        if let availablePack = allPacks.sorted(by: { $0.number < $1.number })
                                       .first(where: { $0.gameLevels?.count ?? 0 < 5 }) {
            
            debugPrint("Found \(availablePack.number) pack with \(availablePack.gameLevels?.count ?? 0) levels")
            

            return availablePack
        }
        debugPrint(">>> No available pack found")
        // 4. If none found, create new pack
        
//        let newPack = PackMO(context: context)
//        newPack.id = UUID()
//        newPack.number = try PackMO.getNextPackNumber(in: context)
//        try context.save()
        
        return try createPackMO()
    }
    
//    func getNextPackNumber() throws -> Int {
//        
//    }
    
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
        debugPrint("CreatePackMO")
        // 1. Get the current max number
        let fetchRequest: NSFetchRequest<PackMO> = PackMO.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "number", ascending: false)]
        fetchRequest.fetchLimit = 1
        
        let maxNumberPack = try context.fetch(fetchRequest).first
        let nextNumber = (maxNumberPack?.number ?? 0) + 1
        debugPrint("nextNumber \(nextNumber)")
        
        // 2. Create new PackMO
        let newPack = PackMO(context: context)
        newPack.id = UUID()
        newPack.number = Int16(nextNumber)
        debugPrint("Pack Id \(String(describing: newPack.id))")
        
        debugPrint("Saved")
        
        
        return newPack
    }

//    public func createPack() throws -> Pack {
//        return try createPackMO().toPack()
//    }
//    
//    
//    
    public func createGameLevel(level: any Level) throws {
        let packMO = try findOrCreateAvailablePack()
        
        let entity = GameLevelMO(context: context)
        debugPrint("PackMO: \(String(describing: packMO.id))")
        
        entity.owningPack = packMO
        
        entity.populate(from: level)
        entity.packId = packMO.id
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
    
    func getPack(packId: UUID) throws -> PackMO? {
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
