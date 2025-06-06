import Foundation


public protocol PlayableLevelRepository: LevelRepository {
}

typealias CoreDataPlayableLevelRepositoryImpl = CoreDataLevelRepository<PlayableLevelMO>


extension CoreDataPlayableLevelRepositoryImpl: PlayableLevelRepository {
    
}





public enum LevelError: Error {
    case notFound
    case invalidData
    case coreDataError(Error)
}
