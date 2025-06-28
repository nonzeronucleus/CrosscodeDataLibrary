import Foundation
import Factory

public protocol ExportLayoutsUseCase {
    func execute(layouts:[Layout]) async throws
}
//
//
struct ExportLayoutsUseCaseImpl: ExportLayoutsUseCase {
    let repository: FileRepository
//
//    // Dependency injected via Factory
//    public init(repository: FileStore) {
//        self.repository = repository
//    }
//
    func execute(layouts:[Layout]) async throws {
        for layout in layouts {
            debugPrint(layout.id.uuidString)
        }
    }
//
////        @Injected(\.uuid) var uuid
////        let currentHighestNum = try await repository.getHighestLevelNumber()
////        
////        let id = uuid.uuidGenerator()
////        let crossword = Crossword(rows: 15, columns: 15)
////        
////
////        let layout = Layout(
////            id: id,
////            number: currentHighestNum+1,
////            gridText: crossword.layoutString()
////        )
////        
////        try repository.create(level: layout)
//    }
}
//
