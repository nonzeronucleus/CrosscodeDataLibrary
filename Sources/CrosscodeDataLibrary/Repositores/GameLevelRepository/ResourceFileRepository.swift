struct ResourceFileRepository: FileRepository {
    let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    var url:URL {
        let  url = Bundle.module.resourceURL
        
        guard url != nil else {
            fatalError("Can't find resource bundle")
        }
        
        return url!.appendingPathComponent(fileName+".json")
    }
    
    func exists() -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    func read() throws -> Data {
        try Data(contentsOf: url)
    }
}
