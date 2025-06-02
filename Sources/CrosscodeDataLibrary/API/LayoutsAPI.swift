import Factory

typealias PopulationTask = Task<(String, String), Error>


public protocol LayoutsAPI: LevelsAPI {
    func populateCrossword(crosswordLayout: String) async throws -> (String, String)
    
    func depopulateCrossword(crosswordLayout: String) async throws -> (String, String)
//    
//    func addNewLayout() async throws -> [LevelLayout]
}


public class LayoutsAPIImpl : LayoutsAPI {
    public func addNewLayout() async throws -> [LevelLayout] {
        return try await addNewLevel() as? [LevelLayout] ?? []
    }
    
// Actor for async operations
    private let actor = CrosscodeAPIActor()
    
    required public init() {
    }
    
    public func importLevels() async throws {
//        fatalError("\(#function) not implemented")
        let importUseCase = Container.shared.importLayoutsUseCase()
        try await importUseCase.execute()
    }

    public func fetchAllLevels() async throws -> [any Level] {
        let fetchAllUseCase = Container.shared.fetchAllLayoutsUseCase()
        return try await fetchAllUseCase.execute()
    }
    
//    public func fetchLayout(id:UUID) async throws -> LevelLayout? {
    public func fetchLevel(id:UUID) async throws -> (any Level)? {
        let fetchLayoutUseCase: FetchLayoutUseCaseProtocol = Container.shared.fetchLayoutUseCase()
        return try await fetchLayoutUseCase.execute(id: id)
    }

    
    public func deleteLevel(id: UUID) async throws -> [any Level] {
        let deleteLayoutUseCase: DeleteLayoutUseCase = Container.shared.deleteLayoutUseCase()
        return try await deleteLayoutUseCase.execute(id: id)
    }
    
    public func saveLevel(level: any Level) async throws {
        let saveLevelUseCase: SaveLevelUseCase = Container.shared.saveLevelUseCase()
        try await saveLevelUseCase.execute(level: level)
    }

    public func cancel() async {
        await actor.cancel()
    }
}


//extension LayoutsAPIImpl {
//    public func importLayouts() async throws {
//        try await importLevels()
//    }
//    
//    public func fetchLayout(id: UUID) async throws -> LevelLayout? {
//        return try await fetchLevel(id: id) as? LevelLayout
//    }
//    
//    public func fetchAllLayouts() async throws -> [LevelLayout] {
//        return try await fetchAllLevels() as? [LevelLayout] ?? []
//    }
//    
//    public func deleteLayout(id: UUID) async throws -> [LevelLayout] {
//        return try await deleteLevel(id: id) as? [LevelLayout] ?? []
//    }
//    
//    public func saveLayout(level: LevelLayout) async throws {
//        try await saveLevel(level: level)
//    }
//}

extension LayoutsAPIImpl {
    public func addNewLevel() async throws -> [any Level] {
        let addLayoutUseCase: AddLayoutUseCaseProtocol = Container.shared.addLayoutUsecase()
        return try await addLayoutUseCase.execute()
    }
    
    public func populateCrossword(crosswordLayout: String) async throws -> (String, String) {
        try await actor.populate(crosswordLayout: crosswordLayout)
    }
    
    public func depopulateCrossword(crosswordLayout: String) async throws -> (String, String) {
        let depopulateCrosswordUseCase: DepopulateCrosswordUseCase = Container.shared.depopulateCrosswordUseCase()
        
        return depopulateCrosswordUseCase.execute(crosswordLayout: crosswordLayout)
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
