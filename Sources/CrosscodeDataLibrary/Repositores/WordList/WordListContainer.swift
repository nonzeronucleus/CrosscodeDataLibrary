import Foundation

class WordListContainer : WordListContainerProtocol {
    let words: [String]
    var wordsByLength: [Int:[String]]
    var origWordsByLength: [Int:[String]]
    var count:Int { words.count }
    
    init() {
        let name = "ukenglish"
        self.words = WordListContainer.loadFile(name)
        self.wordsByLength = WordListContainer.groupWordsByLength(words: words)
        self.origWordsByLength = wordsByLength
    }
    
    func getWordsByLength(length:Int) -> [String] {
        let words = wordsByLength[length] ?? []
        return words
    }
    
    func removeWord(word:String) {
        wordsByLength[word.count]?.removeAll { $0 == word }
    }
    
    func reset(forLength length:Int) {
        wordsByLength[length] = origWordsByLength[length]
    }
    
    func addWord(word:String) {
        wordsByLength[word.count]?.append(word)
    }
    
    static func groupWordsByLength(words: [String]) -> [Int:[String]] {
        var wordsByLength: [Int:[String]] = [:]
        
        for word in words {
            var matchingWords = wordsByLength[word.count] ?? []
            
            matchingWords.append(word)
            wordsByLength[word.count] = matchingWords
        }
        return wordsByLength
    }
    
    static private func loadFile(_ name:String) -> [String] {
        guard let file = Bundle.module.url(forResource: name, withExtension: "txt") else {
            fatalError("Failed to load ukenglish.txt from module bundle")
        }
        do {
            let data = try String(contentsOfFile:file.path, encoding: String.Encoding.ascii)
            return data.components(separatedBy: "\n")
        }
        catch let err as NSError {
            fatalError(err.description)
        }
    }
    
//    static func printResourceNamesAndPaths() {
//        guard let resourceRoot = Bundle.module.resourceURL else {
//            print("Bundle.module has no resourceURL")
//            return
//        }
//
//        let rootPath = resourceRoot.path
//
//        if let enumerator = FileManager.default.enumerator(at: resourceRoot, includingPropertiesForKeys: nil) {
//            for case let fileURL as URL in enumerator {
//                guard fileURL.pathExtension == "txt" else { continue }
//
//                let fullPath = fileURL.path
//                let relativePath = String(fullPath.dropFirst(rootPath.count + 1))  // Remove root + "/"
//                let components = relativePath.components(separatedBy: "/")
//
//                let fileNameWithExtension = components.last ?? ""
//                let fileName = fileNameWithExtension.replacingOccurrences(of: ".txt", with: "")
//                let subdirectory = components.dropLast().joined(separator: "/")
//
//                print("✅ To access this file:")
//                if subdirectory.isEmpty {
//                    print("   Bundle.module.url(forResource: \"\(fileName)\", withExtension: \"txt\")")
//                } else {
//                    print("   Bundle.module.url(forResource: \"\(fileName)\", withExtension: \"txt\", subdirectory: \"\(subdirectory)\")")
//                }
//
//                print("   Full path: \(fullPath)")
//                print()
//            }
//        }
//    }
}


//
//static private func loadFile() -> [String] {
//    for url in Bundle.module.urls(forResourcesWithExtension: "txt", subdirectory: "Words") ?? [] {
//        debugPrint("Found .txt file: \(url)")
//    }
//    
//    debugPrint("Bundle.module resource URL: \(Bundle.module.resourceURL?.path ?? "nil")")
//    
//    guard let file = Bundle.module.url(forResource: "Resources/Words/ukenglish", withExtension: "txt") else {
//        fatalError("Failed to load ukenglish.txt from module bundle")
//    }
//    do {
//        let data = try String(contentsOfFile:file.path, encoding: String.Encoding.ascii)
//        return data.components(separatedBy: "\n")
//    }
//    catch let err as NSError {
//        fatalError(err.description)
//    }
//}
