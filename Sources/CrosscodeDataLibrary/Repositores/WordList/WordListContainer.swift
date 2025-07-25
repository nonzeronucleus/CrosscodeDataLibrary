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
    
    func containsWord(_ word: String) -> Bool {
        return words.contains(word)
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
}
