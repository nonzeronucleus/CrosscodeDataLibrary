import Foundation
import Factory

public protocol ImportLayoutsUseCase {
    func execute() async throws
}


class ImportLayoutsUseCaseImpl: ImportLayoutsUseCase {
    private let repository: LayoutRepository
    private let fileRepository: LayoutRepository

    // Dependency injected via Factory
    public init(repository: LayoutRepository, fileRepository: LayoutRepository) {
        self.repository = repository
        self.fileRepository = fileRepository
    }
    
    func execute() async throws {
        let layouts: [LevelLayout] = try await fileRepository.fetchAllLayouts()
        
        for layout in layouts {
            if try await repository.fetchLayout(id: layout.id) == nil {
                // Layout doesn't exist so add it
                try repository.create(level: layout)
            }
        }
    }
}
