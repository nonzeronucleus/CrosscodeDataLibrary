import Foundation
import Factory

protocol AddPlayableLevelUseCase {
    func execute(layout: LevelLayout) throws -> PlayableLevel
}

struct AddPlayableLevelUseCaseImpl: AddPlayableLevelUseCase {
    private let repository: PlayableLevelRepository

    public init(repository: PlayableLevelRepository = Container.shared.playableLevelRepository()) {
        self.repository = repository
    }

    func execute(layout: LevelLayout) throws -> PlayableLevel {
        fatalError("\(#function) not implemented")
    }
}
