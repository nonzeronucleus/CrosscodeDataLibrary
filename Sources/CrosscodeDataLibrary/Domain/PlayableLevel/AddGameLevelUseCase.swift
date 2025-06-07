import Foundation
import Factory

protocol AddGameLevelUseCase {
    func execute(layout: Layout) async throws 
}

struct AddGameLevelUseCaseImpl: AddGameLevelUseCase {
    private let repository: GameLevelRepository

    public init(repository: GameLevelRepository) {
        self.repository = repository
    }

    func execute(layout: Layout) async throws {
        @Injected(\.uuid) var uuid
        let currentHighestNum = try await repository.getHighestLevelNumber()
        let gameLevel = GameLevel(layout: layout, id: uuid(), number: currentHighestNum + 1)
                
        try repository.create(level: gameLevel)
    }
}
