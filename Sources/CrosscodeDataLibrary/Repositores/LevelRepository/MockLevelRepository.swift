import Factory

class MockLevelRepository:LevelRepository {
    var levels: [Level] = []
    
    private init() {
    }
 
    static func create() -> LevelRepository {
        do {
            let instance = MockLevelRepository()
            
            @Injected(\.uuid) var uuid
            //        let crossword = Crossword(rows: 15, columns: 15)
            let layout = try Level(
                id: uuid.uuidGenerator(),
                number: instance.getHighestLevelNumber() + 1,
                packId: nil,
                gridText: "    .    .. ...| ..  .. ... . .| .. ... ...    |    ..    ... .|. .  ... .... .|. ....   .... .|       .      .|...... . ......|.      .       |. ....   .... .|. .... ...  . .|. ...    ..    |    ... ... .. |. . ... ..  .. |... ..    .    |",
                attemptedLetters: ""
            )
            
            try instance.create(level: layout) // this is safe because `instance` is fully initialized
            return instance
        }
        catch {
            fatalError("Unable to create MockLevelRepository: \(error)")
        }
    }
    
    func create(level: Level) throws {
        levels.append(level)
    }
    
    func fetchAllLayouts() async throws -> [Level] {
        return levels
    }
    
    func getHighestLevelNumber() throws -> Int {
        return levels.count
    }
    
    func deleteLayout(id: UUID) async throws {
        
    }
}
//.    .. ...| ..  .. ... . .| .. ... ...    |    ..    ... .|. .  ... .... .|. ....   .... .|       .      .|...... . ......|.      .       |. ....   .... .|. .... ...  . .|. ...    ..    |    ... ... .. |. . ... ..  .. |... ..    .    |"},{"number":2,"gridText":"     ..........|   . ..........|     ..........|.. ............|.. ............|.     .........|.....     .....|..... ... .....|.....     .....|.........     .|............ ..|............ ..|..........     |.......... .   |..........     |
