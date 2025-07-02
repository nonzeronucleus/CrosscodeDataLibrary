import Foundation
import Factory

protocol AddPackUseCase {
    func execute() async throws -> Pack
}

struct AddPackUseCaseImpl: AddPackUseCase {
    private let repository: GameLevelRepository

    public init(repository: GameLevelRepository) {
        self.repository = repository
    }

    func execute() async throws -> Pack {
        return try repository.createPack()
    }
}
