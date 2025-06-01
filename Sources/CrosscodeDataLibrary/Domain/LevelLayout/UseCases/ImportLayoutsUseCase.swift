import Foundation
import Factory

public protocol ImportLayoutsUseCase {
    func execute() async throws
}


class ImportLayoutsUseCaseImpl: ImportLayoutsUseCase {
    private let repository: LevelRepository
    private let fileRepository: LayoutRepository

    // Dependency injected via Factory
    public init(repository: LevelRepository, fileRepository: LayoutRepository) {
        self.repository = repository
        self.fileRepository = fileRepository
    }
    
    func execute() async throws {
        fatalError("\(#function) not implemented")
//        let layouts: [any Level] = try await fileRepository.fetchAll()
        
        
//        for layout in layouts {
//            if try await repository.fetch(id: layout.id) == nil {
//                // Layout doesn't exist so add it
//                try repository.create(level: layout)
//            }
//        }
    }
}
