import Factory

class MockLevelRepository:LevelRepository {
    var levels: [LevelLayout] = []
    
    private init() {
    }
 
    static func create() -> LevelRepository {
        do {
            let instance = MockLevelRepository()
            
            @Injected(\.uuid) var uuid
            //        let crossword = Crossword(rows: 15, columns: 15)
            let layout = try LevelLayout(
                id: uuid.uuidGenerator(),
                number: instance.getHighestLevelNumber() + 1,
//                packId: nil,
                gridText: "    .    .. ...| ..  .. ... . .| .. ... ...    |    ..    ... .|. .  ... .... .|. ....   .... .|       .      .|...... . ......|.      .       |. ....   .... .|. .... ...  . .|. ...    ..    |    ... ... .. |. . ... ..  .. |... ..    .    |",
//                attemptedLetters: ""
            )
            
            try instance.create(level: layout) // this is safe because `instance` is fully initialized
            return instance
        }
        catch {
            fatalError("Unable to create MockLevelRepository: \(error)")
        }
    }
    
    func saveLevel(level: LevelLayout) throws {
        guard let index = levels.firstIndex(where: { $0.id == level.id }) else {
            throw LevelError.notFound
        }
        levels[index] = level
    }

    
    func create(level: LevelLayout) throws {
        levels.append(level)
    }
    
    func fetchLayout(id: UUID) async throws -> LevelLayout {
        guard let index = levels.firstIndex(where: { $0.id == id }) else {
            throw LevelError.notFound
        }
        return levels[index]
    }

    
    func fetchAllLayouts() async throws -> [LevelLayout] {
        return levels
    }
    
    func getHighestLevelNumber() throws -> Int {
        return levels.count
    }
    
    func deleteLayout(id: UUID) async throws {
        
    }
}
