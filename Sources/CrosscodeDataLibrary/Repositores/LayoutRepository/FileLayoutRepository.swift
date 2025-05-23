struct FileLayoutRepository : LayoutRepository {
    let resourceFile = ResourceFileStorage(fileName: "Layouts.json")
    
    func create(level: LevelLayout) throws {
        fatalError("\(#function) not implemented")
    }
    
    func saveLevel(level: LevelLayout) throws {
        fatalError("\(#function) not implemented")
    }
    
    func fetchAllLayouts() async throws -> [LevelLayout] {
        return try await readFromFile(fresourceFile: resourceFile)
    }
    
    func fetchLayout(id: UUID) async throws -> LevelLayout? {
        fatalError("\(#function) not implemented")
    }
    
    func getHighestLevelNumber() async throws -> Int {
        fatalError("\(#function) not implemented")
    }
    
    func deleteLayout(id: UUID) async throws {
        fatalError("\(#function) not implemented")
    }
}

extension FileLayoutRepository {
    private func readFromFile(fresourceFile: ResourceFileStorage) async throws -> [LevelLayout] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let jsonData = try Data(contentsOf: resourceFile.url)
            let levelDefs = try decoder.decode([LevelLayout].self, from: jsonData)
            
            return levelDefs
        }
    }
}



