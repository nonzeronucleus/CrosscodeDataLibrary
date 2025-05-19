import Factory

class MockLevelRepository:LevelRepository {
    var levels: [Layout] = []
    
    private init() {
    }
 
    static func create() -> LevelRepository {
        do {
            let instance = MockLevelRepository()
            
            @Injected(\.uuid) var uuid
            //        let crossword = Crossword(rows: 15, columns: 15)
            let layout = try Layout(
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
    
    func saveLevel(level: Layout) throws {
        guard let index = levels.firstIndex(where: { $0.id == level.id }) else {
            throw LevelError.notFound
        }
        levels[index] = level
//        debugPrint("Saving level \(level.id), \(level.crossword.layoutString())")
    }

    
    func create(level: Layout) throws {
        levels.append(level)
    }
    
    func fetchLayout(id: UUID) async throws -> Layout {
        guard let index = levels.firstIndex(where: { $0.id == id }) else {
            throw LevelError.notFound
        }
        return levels[index]
    }

    
    func fetchAllLayouts() async throws -> [Layout] {
        return levels
    }
    
    func getHighestLevelNumber() throws -> Int {
        return levels.count
    }
    
    func deleteLayout(id: UUID) async throws {
        
    }
}
