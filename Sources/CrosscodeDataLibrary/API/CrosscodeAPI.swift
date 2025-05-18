import Factory

typealias PopulationTask = Task<(String, String), Error>

public class CrosscodeAPI {
    public static var shared: Self {
        Container.shared.setupTestMocks()
        return .init()
    }
    
    // Injected dependencies
    private let repository: LevelRepository

    // Actor for async operations
    private let actor = CrosscodeAPIActor()


    required public init(
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
    
    public func saveLevel(level: Level) async throws {
        let saveLevelUseCase: SaveLevelUseCase = Container.shared.saveLevelUseCase()
        try await saveLevelUseCase.execute(level: level)
    }
    
    public func populateCrossword(crosswordLayout: String) async throws -> (String, String) {
        try await actor.populate(crosswordLayout: crosswordLayout)
    }
    
    public func depopulateCrossword(crosswordLayout: String) async throws -> (String, String) {
        let depopulateCrosswordUseCase: DepopulateCrosswordUseCase = Container.shared.depopulateCrosswordUseCase()
        
        return depopulateCrosswordUseCase.execute(crosswordLayout: crosswordLayout)
    }
    
    
    public func cancel() async {
        await actor.cancel()
    }
    
}

private actor CrosscodeAPIActor {
    // Change the task type to match what your task actually returns
    private var currentTask: PopulationTask?
    
    func populate(crosswordLayout: String) async throws -> (String, String) {
        // Cancel previous task if exists
        currentTask?.cancel()
        
        // Create and store new task with correct type
        let task = Task<(String, String), Error> {
            try await executePopulation(crosswordLayout: crosswordLayout)
        }
        currentTask = task
        
        return try await task.value
    }
    
    private func executePopulation(crosswordLayout: String) async throws -> (String, String) {
        let useCase = Container.shared.populateCrosswordUseCase()
        let ret = try await useCase.execute(task: currentTask, crosswordLayout: crosswordLayout)
        return ret
    }
    
    // Explicit cancellation method
    func cancel() {
        currentTask?.cancel()
        currentTask = nil
    }
}
