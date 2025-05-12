import Foundation

protocol FetchAllLayoutsUseCase {
    func execute() async throws -> [Level]
}


struct FetchAllLayoutsUseCaseImpl: FetchAllLayoutsUseCase {
    private let repository: LevelRepository
    
    public init(repository: LevelRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [Level] {
        return try await repository.fetchAllLayouts()
    }
    
}
