import Foundation

struct DocumentFileRepository:FileRepository {
    let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    var url:URL {
        do {
            let url = try FileManager.default.url(for: .documentDirectory,
                                                                in: .userDomainMask,
                                                                appropriateFor: nil,
                                                                create: false)
            return url.appendingPathComponent(fileName+".json")
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func exists() -> Bool {
        return FileManager.default.fileExists(atPath: url.path)
    }
    
    func read() throws -> Data {
        try Data(contentsOf: url)
    }
}
