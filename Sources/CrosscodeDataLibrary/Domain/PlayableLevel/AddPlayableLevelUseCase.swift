import Foundation
import Factory

protocol AddPlayableLevelUseCase {
    func execute(layout: Level) throws -> Level
}

struct AddPlayableLevelUseCaseImpl: AddPlayableLevelUseCase {
    private let repository: LevelRepository

    public init(repository: LevelRepository = Container.shared.levelRepository()) {
        self.repository = repository
    }

    func execute(layout: Level) throws -> Level {
        fatalError("\(#function) not implemented")
    }
}
