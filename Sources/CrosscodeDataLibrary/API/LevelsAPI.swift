public enum APIType {
    case layoutsAPI
    case gameLevelsAPI
}


public protocol LevelsAPI {
    func importLevels() async throws
    
    func fetchLevel(id:UUID) async throws -> (any Level)?

    func fetchAllLevels() async throws -> [any Level]

    func deleteLevel(id: UUID) async throws
    
    func saveLevel(level: any Level) async throws

    func cancel() async
    
    func printTest()
}
