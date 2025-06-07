import Foundation


public protocol GameLevelRepository: LevelRepository {
}

typealias CoreDataGameLevelRepositoryImpl = CoreDataLevelRepository<GameLevelMO>


extension CoreDataGameLevelRepositoryImpl: GameLevelRepository {
    
}





public enum LevelError: Error {
    case notFound
    case invalidData
    case coreDataError(Error)
}
