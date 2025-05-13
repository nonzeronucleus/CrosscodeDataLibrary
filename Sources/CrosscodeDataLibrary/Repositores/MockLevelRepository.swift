import Factory

class MockLevelRepository:LevelRepository {
    var levels: [Level] = []
    
    init() {
        Task {
            do {
                @Injected(\.uuid) var uuid
                let crossword = Crossword(rows: 15, columns: 15)
                
                let layout = try await Level(
                    id: uuid.uuidGenerator(),
                    number: getHighestLevelNumber()+1,
                    packId: nil,
                    gridText: crossword.layoutString(),
                    attemptedLetters: ""
                )
                try create(level: layout)
            }
        }
    }
    
    func create(level: Level) throws {
        levels.append(level)
    }
    
    func fetchAllLayouts() async throws -> [Level] {
        return levels
    }
    
    func getHighestLevelNumber() async throws -> Int {
        return levels.count
    }
    
    func deleteLayout(id: UUID) async throws {
        
    }
}
