import Foundation
import Factory

public protocol ExportLayoutsUseCase {
    func execute(layouts:[Layout]) async throws
}

struct ExportLayoutsUseCaseImpl: ExportLayoutsUseCase {
    let repository: FileRepository
    func execute(layouts:[Layout]) async throws {
//        debugPrint("Exporting to \(repository.url)")
        let jsonData = try JSONEncoder().encode(layouts)
        try jsonData.write(to: repository.url)
    }
}
