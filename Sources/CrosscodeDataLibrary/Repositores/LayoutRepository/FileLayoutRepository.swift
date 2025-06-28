struct FileLayoutRepository /*: LayoutRepository*/ {
}
//    func create(level: any Level) throws {
//        fatalError("\(#function) not implemented")
//    }
//    
//    let resourceFile = ResourceFileStorage(fileName: "Layouts.json")
//    
//    func create(level: Layout) throws {
//        fatalError("\(#function) not implemented")
//    }
//    
//    func save(level: any Level) throws {
//        fatalError("\(#function) not implemented")
//    }
//    
//    func fetchAll() async throws -> [any Level] {
//        return try await readFromFile(fresourceFile: resourceFile)
//    }
//    
//    func fetch(id: UUID) async throws -> (any Level)? {
//        fatalError("\(#function) not implemented")
//    }
//    
//    func getHighestLevelNumber() async throws -> Int {
//        fatalError("\(#function) not implemented")
//    }
//    
//    func delete(id: UUID) async throws {
//        fatalError("\(#function) not implemented")
//    }
//}
//
//extension FileLayoutRepository {
//    private func readFromFile(fresourceFile: ResourceFileStorage) async throws -> [any Level] {
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        
//        do {
//            let jsonData = try Data(contentsOf: resourceFile.url)
//            let levelDefs = try decoder.decode([Layout].self, from: jsonData)
//            
//            return levelDefs
//        }
//    }
//}



