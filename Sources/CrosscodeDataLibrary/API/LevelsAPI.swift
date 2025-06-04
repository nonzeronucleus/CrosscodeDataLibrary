public enum APIType {
    case layoutsAPI
    case playableLevelsAPI
}


public protocol LevelsAPI {
    func importLevels() async throws
    
//    func addNewLevel() async throws -> [any Level]

    func fetchLevel(id:UUID) async throws -> (any Level)?

    func fetchAllLevels() async throws -> [any Level]

    func deleteLevel(id: UUID) async throws -> [any Level]
    
    func saveLevel(level: any Level) async throws

    func cancel() async
    
    func printTest()
}
