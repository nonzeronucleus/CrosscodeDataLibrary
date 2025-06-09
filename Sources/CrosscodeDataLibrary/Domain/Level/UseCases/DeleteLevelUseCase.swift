import Foundation
import Factory

public protocol DeleteLevelUseCase {
    func execute(id: UUID) async throws
}


public final class DeleteLevelUseCaseImpl: DeleteLevelUseCase {
    private let repository: LevelRepository
    
    // Dependency injected via Factory
    public init(repository: LevelRepository) {
        self.repository = repository
    }
    
    public func execute(id: UUID) async throws {
        try await repository.delete(id: id)
    }
}


final class MockDeleteLevelUseCaseImpl: DeleteLevelUseCase {
    var mockLevels: [any Level] = []
    var errorToThrow: Error?
    
    func execute(id: UUID) async throws {
        if let error = errorToThrow { throw error }
    }
}
