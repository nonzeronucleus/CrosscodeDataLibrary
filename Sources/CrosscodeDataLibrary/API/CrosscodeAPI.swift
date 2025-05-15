import Factory

public struct CrosscodeAPI {
    public static var shared: Self {
        Container.shared.setupTestMocks()
        return .init()
    }
    
    // Injected dependencies
    private let repository: LevelRepository
    
    public init(
        repository: LevelRepository = Container.shared.levelRepository()
    ) {
        self.repository = repository
    }

    public func addNewLayout() async throws -> [Level] {
        let addLayoutUseCase: AddLayoutUseCaseProtocol = Container.shared.addLayoutUsecase()
        return try await addLayoutUseCase.execute()
    }
    
    public func fetchAllLayouts() async throws -> [Level] {
        let fetchAllUseCase: FetchAllLayoutsUseCaseProtocol = Container.shared.fetchAllLayoutsUseCase()
        return try await fetchAllUseCase.execute()
    }
    
    public func deleteLayout(id: UUID) async throws -> [Level] {
        let deleteLayoutUseCase: DeleteLayoutUseCase = Container.shared.deleteLayoutUseCase()
        return try await deleteLayoutUseCase.execute(id: id)
    }
    
    public func populateCrossword(crossword:Crossword) async throws ->  (Crossword, CharacterIntMap) {
        let populateCrosswordUseCase: CrosswordPopulatorUseCaseProtocol = Container.shared.populateCrosswordUseCase()
        return try await populateCrosswordUseCase.execute(initCrossword:crossword)
    }

}





