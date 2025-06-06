import Foundation
import Factory

protocol AddPlayableLevelUseCase {
    func execute(layout: LevelLayout) async throws 
}

struct AddPlayableLevelUseCaseImpl: AddPlayableLevelUseCase {
    private let repository: PlayableLevelRepository

    public init(repository: PlayableLevelRepository) {
        self.repository = repository
    }

    func execute(layout: LevelLayout) async throws {
//        let playableLevel = PlayableLevel(layout: layout)

        fatalError("\(#function) not implemented")
    }
}
