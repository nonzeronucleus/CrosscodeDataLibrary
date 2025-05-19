import Foundation
import Factory

public protocol FetchAllLayoutsUseCaseProtocol {
    func execute() async throws -> [Layout]
}


public final class FetchAllLayoutsUseCase: FetchAllLayoutsUseCaseProtocol {
    private let repository: LevelRepository
    
    // Dependency injected via Factory
    public init(repository: LevelRepository = Container.shared.levelRepository()) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Layout] {
        try await repository.fetchAllLayouts()
    }
}


final class MockFetchAllLayoutsUseCase: FetchAllLayoutsUseCaseProtocol {
    var mockLevels: [Layout] = []
    var errorToThrow: Error?
    
    func execute() async throws -> [Layout] {
        if let error = errorToThrow { throw error }
        return mockLevels
    }
}
