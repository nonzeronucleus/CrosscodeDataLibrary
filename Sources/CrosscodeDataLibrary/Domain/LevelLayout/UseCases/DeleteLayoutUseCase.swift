import Foundation
import Factory

public protocol DeleteLayoutUseCase {
    func execute(id: UUID) async throws -> [LevelLayout]
}


public final class DeleteLayoutUseCaseImpl: DeleteLayoutUseCase {
    private let repository: LayoutRepository
    
    // Dependency injected via Factory
    public init(repository: LayoutRepository) {
        self.repository = repository
    }
    
    public func execute(id: UUID) async throws -> [LevelLayout] {
        try await repository.delete(id: id)

        return try await repository.fetchAll()
    }
}


final class MockDeleteLayoutUseCaseImpl: DeleteLayoutUseCase {
    var mockLevels: [LevelLayout] = []
    var errorToThrow: Error?
    
    func execute(id: UUID) async throws -> [LevelLayout] {
        if let error = errorToThrow { throw error }
        return mockLevels
    }
}
