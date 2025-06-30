import Factory
//
//typealias PopulationTask = Task<(String, String), Error>
//


public protocol GameLevelsAPI : LevelsAPI {
    func addNewLevel(layout:Layout) async throws
    func exportGameLevels() async throws
    func importGameLevels() async throws -> [GameLevel]

}

public class GameLevelsAPIImpl:GameLevelsAPI{
    required public init() {
    }
    
    public func addNewLevel(layout:Layout) async throws {
        let addGameLevelUseCase: AddGameLevelUseCase = Container.shared.addGameLevelUsecase()
        
        try await addGameLevelUseCase.execute(layout: layout)
    }
    
    public func importGameLevels() async throws  -> [GameLevel]{
        fatalError("\(#function) not implemented")
    }
    
    public func exportGameLevels() async throws {
        let exportGameLevelsUseCase: ExportGameLevelsUseCase = Container.shared.exportGameLevelsUseCase()
        return try await exportGameLevelsUseCase.execute()
    }
    
    
    public func fetchLevel(id:UUID) async throws -> (any Level)? {
        let fetchGameLevelUseCase: FetchLevelUseCaseProtocol = Container.shared.fetchGameLevelUseCase()
        return try await fetchGameLevelUseCase.execute(id: id)
    }
    
    public func fetchAllLevels() async throws -> [any Level] {
        let fetchAllUseCase = Container.shared.fetchAllGameLevelssUseCase()
        return try await fetchAllUseCase.execute()
    }
    
    public func deleteLevel(id: UUID) async throws {
        fatalError("\(#function) not implemented")
    }
    
    public func saveLevel(level: any Level) async throws {
        fatalError("\(#function) not implemented")
    }
    
    public func cancel() async {
        fatalError("\(#function) not implemented")
    }
    
    public func addNewLevel(layout:Layout) async throws -> GameLevel {
        fatalError("\(#function) not implemented")
        //        let addNewLevelUseCase: AddGameLevelUseCase = Container.shared.addGameLevelUseCase()
        //        return try addNewLevelUseCase.execute(layout: layout)
    }
    public func printTest() {
        print("GameLevelsAPIImpl")
    }
}
