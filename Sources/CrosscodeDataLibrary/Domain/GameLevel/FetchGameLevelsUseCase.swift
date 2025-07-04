import Foundation
import Factory

public protocol FetchGameLevelsUseCase {
    func execute(packId: UUID) async throws -> [GameLevel]
}


public final class FetchGameLevelsUseCaseImpl: FetchGameLevelsUseCase {
    private let repository: GameLevelRepository
    
    public init(repository: GameLevelRepository) {
        self.repository = repository
    }
    
    public func execute(packId: UUID) async throws -> [GameLevel] {
//        try repository.establishRelationships()
//        try repository.findOrCreateAvailablePack()
        return try repository.fetchtGameLevels(packId: packId)
    }
}


final class MockFetchGameLevelsUseCaseImpl: FetchGameLevelsUseCase {
    var mockLevels: [GameLevel] = []
    var errorToThrow: Error?
    
    func execute(packId: UUID) async throws -> [GameLevel] {
        if let error = errorToThrow { throw error }
        return mockLevels
    }
}
