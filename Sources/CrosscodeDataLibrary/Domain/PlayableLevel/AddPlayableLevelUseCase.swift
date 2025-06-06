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
        @Injected(\.uuid) var uuid
        let currentHighestNum = try await repository.getHighestLevelNumber()
        let playableLevel = PlayableLevel(layout: layout, id: uuid(), number: currentHighestNum + 1)
//            id: UUID(),
//            number: playableLevel = PlayableLevel(id: uuid(), layout: layout)
        //            id: UUID(),
        //            number: currentHighestNum + 1,
        //            layout: layout
        //        )
        //        try await repository.save(level: playableLevel)
                
            try repository.create(level: playableLevel)
        
//        debugPrint(currentHighestNum)

//        fatalError("\(#function) not implemented")
    }
}
