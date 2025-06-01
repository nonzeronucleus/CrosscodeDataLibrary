import Foundation
import Factory

public protocol FetchAllLevelsUseCaseProtocol {
    func execute() async throws -> [any Level]
}


public final class FetchAllLevelsUseCase: FetchAllLevelsUseCaseProtocol {
    private let repository: LevelRepository
    
    // Dependency injected via Factory
    public init(repository: LevelRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [any Level] {
        try await repository.fetchAll()
    }
}


final class MockFetchAllLevelsUseCase: FetchAllLevelsUseCaseProtocol {
    var mockLevels: [any Level] = []
    var errorToThrow: Error?
    
    func execute() async throws -> [any Level] {
        if let error = errorToThrow { throw error }
        return mockLevels
    }
}
