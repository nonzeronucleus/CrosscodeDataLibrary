import Foundation
import Factory

public protocol AddLayoutUseCaseProtocol {
    func execute() async throws
}


class AddLayoutUseCase: AddLayoutUseCaseProtocol {
    private let repository: LevelRepository

    // Dependency injected via Factory
    public init(repository: LevelRepository) {
        self.repository = repository
    }

    func execute() async throws {
        @Injected(\.uuid) var uuid
        let currentHighestNum = try await repository.getHighestLevelNumber()
        
        let id = uuid.uuidGenerator()
        let crossword = Crossword(rows: 15, columns: 15)
        

        let layout = LevelLayout(
            id: id,
            number: currentHighestNum+1,
            gridText: crossword.layoutString()
        )
        
        try repository.create(level: layout)
    }
}

