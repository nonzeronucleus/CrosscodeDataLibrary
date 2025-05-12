import Foundation

//protocol AddLayoutUseCaseProtocol {
//    func execute() async throws -> [Level]
//}
//
//
//class AddLayoutUseCase: AddLayoutUseCaseProtocol {
//    var levelRepository: LayoutRepositoryProtocol
//
//    init(levelRepository: LayoutRepositoryProtocol) {
//        self.levelRepository = levelRepository
//    }
//
//    func execute() async throws -> [LevelDefinition] {
//        @Dependency(\.uuid) var uuid
//
//        let nextNum = try levelRepository.fetchHighestLevelNumber(levelType: .layout, packId: nil) + 1
//
//        let layout = LevelDefinition(
//            id: uuid(),
//            number: nextNum,
//            packId: nil,
//            attemptedLetters: ""
//        )
//
//        try await levelRepository.prepareLevelMO(from: layout)
//
//        levelRepository.commit()
//
//        return try await levelRepository.fetchLayouts()
//    }
//}

