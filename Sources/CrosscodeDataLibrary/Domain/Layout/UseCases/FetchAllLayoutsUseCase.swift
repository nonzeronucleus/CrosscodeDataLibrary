import Foundation
import Factory

public protocol FetchAllLayoutsUseCaseProtocol {
    func execute() async throws -> [LevelLayout]
}


public final class FetchAllLayoutsUseCase: FetchAllLayoutsUseCaseProtocol {
    private let repository: LayoutRepository
    
    // Dependency injected via Factory
    public init(repository: LayoutRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [LevelLayout] {
        try await repository.fetchAllLayouts()
    }
}


final class MockFetchAllLayoutsUseCase: FetchAllLayoutsUseCaseProtocol {
    var mockLevels: [LevelLayout] = []
    var errorToThrow: Error?
    
    func execute() async throws -> [LevelLayout] {
        if let error = errorToThrow { throw error }
        return mockLevels
    }
}
