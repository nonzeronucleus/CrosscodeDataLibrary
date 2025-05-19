import Foundation
import Factory

public protocol AddLayoutUseCaseProtocol {
    func execute() async throws -> [Layout]
}


class AddLayoutUseCase: AddLayoutUseCaseProtocol {
    private let repository: LevelRepository

    // Dependency injected via Factory
    public init(repository: LevelRepository = Container.shared.levelRepository()) {
        self.repository = repository
    }

    func execute() async throws -> [Layout] {
        @Injected(\.uuid) var uuid
        let currentHighestNum = try await repository.getHighestLevelNumber()
        
        let id = uuid.uuidGenerator()
        let crossword = Crossword(rows: 15, columns: 15)
        

        let layout = Layout(
            id: id,
            number: currentHighestNum+1,
            gridText: crossword.layoutString()
        )
        
        try repository.create(level: layout)
        return try await repository.fetchAllLayouts()
    }
}

