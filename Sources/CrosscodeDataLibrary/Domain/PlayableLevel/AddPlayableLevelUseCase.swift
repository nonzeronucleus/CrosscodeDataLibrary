import Foundation
import Factory

protocol AddPlayableLevelUseCase {
    func execute(layout: LevelLayout) throws -> PlayableLevel
}

struct AddPlayableLevelUseCaseImpl: AddPlayableLevelUseCase {
    private let repository: LevelRepository

    public init(repository: LevelRepository = Container.shared.levelRepository()) {
        self.repository = repository
    }

    func execute(layout: LevelLayout) throws -> PlayableLevel {
        fatalError("\(#function) not implemented")
    }
}
