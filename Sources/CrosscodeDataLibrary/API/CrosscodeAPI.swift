import Swinject

//public let crosscodeAPI = DIContainer.shared.resolve(CrosscodeAPI.self)

public struct CrosscodeAPI {
    private let repository: LevelRepository
    private let di: DIAssembly
    
    // Internal init for testing
    internal init(repository: LevelRepository, di: DIAssembly = .shared) {
        self.repository = repository
        self.di = di
    }
    
    public static func make() -> CrosscodeAPI {
        let di = DIAssembly.shared
        let repository = di.resolve(LevelRepository.self)
        return CrosscodeAPI(repository: repository, di: di)
    }
    
    public func createLayout(level: Level) throws {
        try repository.create(level: level)
    }
    
    public func fetchAllLayouts() async throws -> [Level] {
         let useCase = di.resolve(FetchAllLayoutsUseCase.self)
         return try await useCase.execute()
    }
    
    public func deleteLayout(id: UUID) async throws {
        try await repository.deleteLayout(id: id)
    }
}
