import Foundation
import Factory

public protocol ExportLayoutsUseCase {
    func execute() async throws
}

struct ExportLayoutsUseCaseImpl: ExportLayoutsUseCase {
    let layoutRepository: LayoutRepository
    let fileRepository: FileRepository

    func execute() async throws {
        let layouts = try await layoutRepository.fetchAll() as! [Layout]
        let jsonData = try JSONEncoder().encode(layouts)
        try jsonData.write(to: fileRepository.url)
    }
}
