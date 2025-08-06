import Factory

typealias PopulationTask = Task<(String, String), Error>


public protocol LayoutsAPI: LevelsAPI {
    func importLayouts() async throws -> [Layout]

    func populateCrossword(crosswordLayout: String) async throws -> (String, String)
    func cancelPopulation()  async
    func depopulateCrossword(crosswordLayout: String) async throws -> (String, String)

    func addNewLayout(crosswordLayout: String?) async throws
    func exportLayouts() async throws
}

extension LayoutsAPI {
    public func addNewLayout() async throws {
        try await addNewLayout(crosswordLayout: nil)
    }
}


public class LayoutsAPIImpl : LayoutsAPI {
    
    public func addNewLayout(crosswordLayout: String? = nil) async throws {
        try await addNewLevel(crosswordLayout: crosswordLayout)
    }
    
    private let actor = CrosscodeAPIActor()
    
    required public init() {
    }
    
    public func exportLayouts() async throws {
        let exportLayoutsUseCase = Container.shared.exportLayoutUseCase()
        try await exportLayoutsUseCase.execute()
    }

    
    public func importLayouts() async throws -> [Layout]{
        let importUseCase = Container.shared.importLayoutsUseCase()
        return try await importUseCase.execute()
    }

    public func fetchAllLevels() async throws -> [any Level] {
        let fetchAllUseCase = Container.shared.fetchAllLayoutsUseCase()
        return try await fetchAllUseCase.execute()
    }
    
    public func fetchLevel(id:UUID) async throws -> (any Level)? {
        let fetchLayoutUseCase: FetchLevelUseCaseProtocol = Container.shared.fetchLayoutUseCase()
        return try await fetchLayoutUseCase.execute(id: id)
    }

    
    public func deleteLevel(id: UUID) async throws {
        let deleteLayoutUseCase: DeleteLevelUseCase = Container.shared.deleteLayoutUseCase()
        try await deleteLayoutUseCase.execute(id: id)
    }
    
    public func saveLevel(level: any Level) async throws {
        let saveGameLayoutstUseCase: SaveLevelUseCase = Container.shared.saveLayoutUseCase()
        try await saveGameLayoutstUseCase.execute(level: level)
    }

    public func cancel() async {
        await actor.cancel()
    }
    
    public func printTest() {
        print("LayoutsAPIImpl")
    }

}


extension LayoutsAPIImpl {
    public func addNewLevel(crosswordLayout: String?) async throws  {
        let addLayoutUseCase: AddLayoutUseCaseProtocol = Container.shared.addLayoutUsecase()
        try await addLayoutUseCase.execute(crosswordLayout: crosswordLayout)
    }
    
    public func populateCrossword(crosswordLayout: String) async throws -> (String, String) {
        try await actor.populate(crosswordLayout: crosswordLayout)
    }
    
    
    public func cancelPopulation() async {
        await actor.cancel()
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
