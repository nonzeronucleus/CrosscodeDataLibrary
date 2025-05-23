import Foundation


public protocol LevelRepository {
    func create(level: LevelLayout) throws
    func saveLevel(level:LevelLayout) throws
    
    func fetchAllLayouts() async throws -> [LevelLayout]
    func fetchLayout(id: UUID) async throws -> LevelLayout

    func getHighestLevelNumber() async throws -> Int
    
    func deleteLayout(id: UUID) async throws
}




public enum LevelError: Error {
    case notFound
    case invalidData
    case coreDataError(Error)
}
