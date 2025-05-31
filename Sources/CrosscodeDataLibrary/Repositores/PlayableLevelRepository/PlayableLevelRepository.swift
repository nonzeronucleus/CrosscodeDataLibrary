import Foundation


public protocol PlayableLevelRepository {
    func create(level: PlayableLevel) throws
    func save(level:PlayableLevel) throws
    
    func fetchAll() async throws -> [PlayableLevel]
    func fetch(id: UUID) async throws -> PlayableLevel

    func getHighestLevelNumber() async throws -> Int
    
    func delete(id: UUID) async throws
}




public enum LevelError: Error {
    case notFound
    case invalidData
    case coreDataError(Error)
}
