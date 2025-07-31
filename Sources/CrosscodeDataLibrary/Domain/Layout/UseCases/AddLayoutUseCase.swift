import Foundation
import Factory

public protocol AddLayoutUseCaseProtocol {
    func execute(crosswordLayout: String? ) async throws
}


class AddLayoutUseCase: AddLayoutUseCaseProtocol {
    private let repository: LevelRepository

    // Dependency injected via Factory
    public init(repository: LevelRepository) {
        self.repository = repository
    }

    func execute(crosswordLayout: String?) async throws {
        @Injected(\.uuid) var uuid
        let currentHighestNum = try await repository.getHighestLevelNumber()
        let id = uuid.uuidGenerator()
        let layoutText = crosswordLayout ?? Crossword.generateGridString(rows: 15, columns: 15)
        let layout = Layout(
            id: id,
            number: currentHighestNum+1,
            gridText: layoutText
        )
        
        try repository.create(level: layout)
    }
}

