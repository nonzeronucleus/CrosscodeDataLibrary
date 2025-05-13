import Foundation
import Factory

public protocol AddLayoutUseCaseProtocol {
    func execute() async throws -> [Level]
}


class AddLayoutUseCase: AddLayoutUseCaseProtocol {
    private let repository: LevelRepository

    // Dependency injected via Factory
    public init(repository: LevelRepository = Container.shared.levelRepository()) {
        self.repository = repository
    }

    func execute() async throws -> [Level] {
        @Injected(\.uuid) var uuid
        let currentHighestNum = try await repository.getHighestLevelNumber()
        
        let id = uuid.uuidGenerator()
        let crossword = Crossword(rows: 15, columns: 15)
        

        let layout = Level(
            id: id,
            number: currentHighestNum+1,
            packId: nil,
            gridText: crossword.layoutString(),
            attemptedLetters: ""
        )
        
        try repository.create(level: layout)
        return try await repository.fetchAllLayouts()
    }
}

