import Foundation
import Factory

public protocol ExportGameLevelsUseCase {
    func execute() async throws
}

struct ExportGameLevelsUseCaseImpl: ExportGameLevelsUseCase {
    let levelRepository: LevelRepository
    let fileRepository: FileRepository
    
    func execute() async throws {
//        debugPrint("Exporting to \(repository.url)")
        let levels = try await levelRepository.fetchAll() as! [GameLevel]

        let jsonData = try JSONEncoder().encode(levels)
        try jsonData.write(to: fileRepository.url)
    }
}
