import Foundation
import Factory

protocol FetchAllPacksUseCase {
    func execute() async throws -> [Pack]
}

struct FetchAllPacksUseCaseImpl: FetchAllPacksUseCase {
    private let repository: GameLevelRepository

    public init(repository: GameLevelRepository) {
        self.repository = repository
    }

    func execute() async throws -> [Pack] {
        return try repository.getPacks()
    }
}
