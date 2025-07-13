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
//        var crossword: Crossword!
//        if let crosswordLayout {
//            let crossword = Crossword(initString: crosswordLayout)
//        }
//        else {
//        let crossword = Crossword(rows: 15, columns: 15)
//        }
        
//
//        debugPrint(crossword.layoutString())
        
        let layoutText = crosswordLayout ?? Crossword.generateGridString(rows: 15, columns: 15)

        let layout = Layout(
            id: id,
            number: currentHighestNum+1,
            gridText: layoutText
                //crossword.layoutString()
        )
        
        try repository.create(level: layout)
    }
}

