import Foundation
import Factory

public protocol DeleteLayoutUseCase {
    func execute(id: UUID) async throws -> [Layout]
}


public final class DeleteLayoutUseCaseImpl: DeleteLayoutUseCase {
    private let repository: LevelRepository
    
    // Dependency injected via Factory
    public init(repository: LevelRepository = Container.shared.levelRepository()) {
        self.repository = repository
    }
    
    public func execute(id: UUID) async throws -> [Layout] {
        try await repository.deleteLayout(id: id)

        return try await repository.fetchAllLayouts()
    }
}


final class MockDeleteLayoutUseCaseImpl: DeleteLayoutUseCase {
    var mockLevels: [Layout] = []
    var errorToThrow: Error?
    
    func execute(id: UUID) async throws -> [Layout] {
        if let error = errorToThrow { throw error }
        return mockLevels
    }
}
