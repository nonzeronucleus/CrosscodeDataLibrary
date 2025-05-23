import Factory

typealias PopulationTask = Task<(String, String), Error>


public protocol LayoutsAPI {
    func test() -> String
    
    func importLayouts() async throws

    func addNewLayout() async throws -> [LevelLayout]
    
    func fetchAllLayouts() async throws -> [LevelLayout]
    
    func deleteLayout(id: UUID) async throws -> [LevelLayout]
    
    func saveLevel(level: LevelLayout) async throws
    
    func populateCrossword(crosswordLayout: String) async throws -> (String, String)
    
    func depopulateCrossword(crosswordLayout: String) async throws -> (String, String)
    
    func cancel() async
}


public class LayoutsAPIImpl : LayoutsAPI {
    // Actor for async operations
    private let actor = CrosscodeAPIActor()
    
    public func test() -> String {
        return "It's a test"
    }



    required public init() {
    }
    
    public func importLayouts() async throws {
        let importUseCase = Container.shared.importLayoutsUseCase()
        try await importUseCase.execute()
    }

    public func addNewLayout() async throws -> [LevelLayout] {
        let addLayoutUseCase: AddLayoutUseCaseProtocol = Container.shared.addLayoutUsecase()
        return try await addLayoutUseCase.execute()
    }
    
    public func fetchAllLayouts() async throws -> [LevelLayout] {
        let fetchAllUseCase: FetchAllLayoutsUseCaseProtocol = Container.shared.fetchAllLayoutsUseCase()
        return try await fetchAllUseCase.execute()
    }
    
    public func deleteLayout(id: UUID) async throws -> [LevelLayout] {
        let deleteLayoutUseCase: DeleteLayoutUseCase = Container.shared.deleteLayoutUseCase()
        return try await deleteLayoutUseCase.execute(id: id)
    }
    
    public func saveLevel(level: LevelLayout) async throws {
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
