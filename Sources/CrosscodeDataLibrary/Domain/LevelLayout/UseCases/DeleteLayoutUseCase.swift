import Foundation
import Factory

public protocol DeleteLayoutUseCase {
    func execute(id: UUID) async throws -> [any Level]
}


public final class DeleteLayoutUseCaseImpl: DeleteLayoutUseCase {
    private let repository: LevelRepository
    
    // Dependency injected via Factory
    public init(repository: LevelRepository) {
        self.repository = repository
    }
    
    public func execute(id: UUID) async throws -> [any Level] {
        try await repository.delete(id: id)

        return try await repository.fetchAll()
    }
}


final class MockDeleteLayoutUseCaseImpl: DeleteLayoutUseCase {
    var mockLevels: [any Level] = []
    var errorToThrow: Error?
    
    func execute(id: UUID) async throws -> [any Level] {
        if let error = errorToThrow { throw error }
        return mockLevels
    }
}
