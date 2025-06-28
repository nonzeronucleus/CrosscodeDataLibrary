//struct ResourceFileStorage {
//    let fileName: String
//    
//    init(fileName: String) {
//        self.fileName = fileName
//    }
//    
//    var url:URL {
//        let  url = Bundle.module.resourceURL
//        
//        guard url != nil else {
//            fatalError("Can't find resource bundle")
//        }
//        
//        return url!.appendingPathComponent(fileName)
//    }
//    
//    func exists() -> Bool {
//        return FileManager.default.fileExists(atPath: url.path)
//    }
//}
