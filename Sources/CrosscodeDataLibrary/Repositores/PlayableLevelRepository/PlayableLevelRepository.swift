import Foundation


public protocol PlayableLevelRepository: LevelRepository {
//    func create(level: PlayableLevel) throws
}




public enum LevelError: Error {
    case notFound
    case invalidData
    case coreDataError(Error)
}
