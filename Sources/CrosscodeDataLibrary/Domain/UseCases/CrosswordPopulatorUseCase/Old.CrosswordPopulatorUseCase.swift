//import Foundation
//
//enum PopulatorError: Error {
//    case cantPopulate
//}
//
//class CrosswordPopulator {
//    let wordlist = WordListContainer()
//    private(set) var entries: [Entry] = []
//    private var crossword:Crossword
//    
//    var alphabetByFrequency = "JQZXFVWBKHMYPCUGILNORSTADE"
//    var letters:[Character] = []
//    
//    init(crossword:Crossword) {
//        self.crossword = crossword
//        entries = findEntries(in: crossword)
//        reset()
//    }
//    
//    func contains(entry:Entry) -> Bool {
//        for existingEntry in entries {
//            if existingEntry.isInSamePos(as:entry){
//                return true
//            }
//        }
//        return false
//    }
//
//    func reset() {
//        crossword.reset()
//    }
//
//    func resetLetters() {
//        letters.removeAll()
//        
//        for char in alphabetByFrequency {
//            letters.append(char)
//        }
//    }
//
//    
//    func populateCrossword(currentTask: PopulationTask?) async throws -> (crossword: Crossword, characterIntMap: CharacterIntMap) {
//        let entryTree = EntryTree(rootEntry: entries.randomElement()!)
//        var populated = false
//        
//        guard let currentTask else {
//            fatalError("currentTask should not be nil")
//        }
//        
//        while !populated && !currentTask.isCancelled {
//            if try await populateNode(node: entryTree.root) {
//                if areAllWordsUnique() {
//                    populated = true
//                }
//            } else {
//                entryTree.resetCount()
//                reset()
//            }
//            
//            // Add small suspension point to allow cancellation checks
//            try Task.checkCancellation()
//            await Task.yield() // Allows other tasks to run
//        }
//        
//        if Task.isCancelled {
//            throw CancellationError()
//        }
//        
//        
//        return (crossword: crossword, characterIntMap: CharacterIntMap(shuffle: true))
//    }
//    
//    private func areAllWordsUnique() -> Bool {
//        var seenWords:[String] = []
//        
//        for entry in entries {
//            let word = getWord(entry: entry)
//            if seenWords.contains(word) {
//                return false
//            }
//            seenWords.append(word)
//        }
//        return true
//    }
//
//    
//    private func populateNode(node: EntryNode) async throws -> Bool {
//        var attempts = 0
//        var childrenPopulated = false
//        let mask = getWord(entry: node.entry)
////        debugPrint("Trying to populate node: \(node.entry)")
//        
//        while !childrenPopulated && !Task.isCancelled {
////            if let index = entries.firstIndex(of: node.entry) {
////                print("Found at index: \(index)")
////            }
////            node.entry.attemptCount += 1
////            if node.entry.attemptCount > 100 {
////                debugPrint("Bailing out due to high count: \(node.entry.attemptCount)")
////                return false
////            }
//            node.increaseCount()
//            
//            if node.getCount() > 100 {
//                return false
//            }
//            
//            childrenPopulated = true
//            upateLettersWithFoundWords()
//            
//            // Check cancellation
//            try Task.checkCancellation()
//            
//            var wordsByLength = wordlist.getWordsByLength(length: mask.count)
//            var matchingWords = wordsByLength.filterByMask(mask: mask)
//            
//            if matchingWords.isEmpty {
//                wordlist.reset(forLength: mask.count)
//                wordsByLength = wordlist.getWordsByLength(length: mask.count)
//                matchingWords = wordsByLength.filterByMask(mask: mask)
//            }
//            
//            var finalWordList: [String] = []
//            var tempLetters = letters
//            
//            while finalWordList.isEmpty && !tempLetters.isEmpty && !Task.isCancelled {
//                let letter = tempLetters.removeFirst()
//                finalWordList = matchingWords.filterContaining(letter: letter)
//            }
//            
//            if finalWordList.isEmpty {
//                finalWordList = matchingWords
//            }
//            
//            if let word = finalWordList.randomElement() {
//                setWord(entry: node.entry, word: word)
//                
//                // Properly await child nodes sequentially
//                for child in node.children {
//                    let childPopulated = try await populateNode(node: child)
//                    childrenPopulated = childrenPopulated && childPopulated
//                    if !childrenPopulated { break }
//                }
//                
//                if !childrenPopulated {
//                    setWord(entry: node.entry, word: mask)
////                    debugPrint("Attempts exceeded \(attempts)")
//                    if attempts > 2 {
//                        return false
//                    }
//                    attempts += 1
//                }
//            } else {
//                return false
//            }
//            
//            await Task.yield()
//        }
////        debugPrint("Failed to populate node")
//        return childrenPopulated
//    }
//    
//    private func getWord(entry:Entry) -> String {
//        var word = ""
//        if entry.length == 0 {
//            return ""
//        }
//
//        let iter = entry.direction == .across ? (0,1) : (1,0)
//
//        for i in 0...entry.length-1 {
//            let pos = Pos(row:entry.startPos.row + iter.0 * i, column: entry.startPos.column + iter.1 * i)
//            let cell = crossword[pos.row, pos.column]
//
//            if let char = cell.letter {
//                word.append(char)
//            }
//        }
//
//        return word
//    }
//
//    func setWord(entry:Entry, word:String) {
//
//        if entry.length == 0 {
//            return
//        }
//        
//        guard word.count == entry.length else { return }
//        
//        let iter = entry.direction == .across ? (0,1) : (1,0)
//        
//        wordlist.removeWord(word: word)
//        entry.word = word
//        
//        for i in 0...entry.length-1 {
//            let index = word.index(word.startIndex, offsetBy: i)
//            let char = word[index]
//            crossword[entry.startPos.row + iter.0 * i, entry.startPos.column + iter.1 * i].letter = char
//        }
//    }
//    
//    func upateLettersWithFoundWords() {
//        resetLetters()
//        for cell in crossword.listElements() {
//            if cell.letter != nil {
//                removeLetter(letter: cell.letter!)
//            }
//        }
//    }
//    
//    func removeLetter(letter: Character) {
//        if let index = letters.firstIndex(of: letter) {
//            letters.remove(at: index)
//        }
//    }
//}
//
//
//
//
//class CrosswordPopulatorUseCase: CrosswordPopulatorUseCaseProtocol {
//    private var currentTask: PopulationTask?
//    
//    func execute(task: PopulationTask?, crosswordLayout: String) async throws -> (String, String) {
//        // Cancel previous task if exists
//        currentTask?.cancel()
//        
//        // Create new task
//        currentTask = task
//        let initCrossword = Crossword(initString: crosswordLayout)
//        let crosswordPopulator = CrosswordPopulator(crossword: initCrossword)
//        let (finalCrossword, charIntMap) = try await crosswordPopulator.populateCrossword(currentTask: task)
//        return (finalCrossword.layoutString(), charIntMap.toJSON())
//        //        return try await currentTask!.value
//    }
//    
//    func cancel() {
//        currentTask?.cancel()
//    }
//}




//extension CrosswordPopulator2 {
//    static func findEntries(in crossword: Crossword, direction: Direction) -> [Entry] {
//        var entries: [Entry] = []
//        var currentEntry: Entry?
//
//        let outerRange = direction == .across ? 0..<crossword.rows : 0..<crossword.columns
//        let innerRange = direction == .across ? 0..<crossword.columns : 0..<crossword.rows
//
//        for outer in outerRange {
//            for inner in innerRange {
//                let row = direction == .across ? outer : inner
//                let col = direction == .across ? inner : outer
//                let cell = crossword[row, col]
//
//                if currentEntry == nil {
//                    if cell.isActive {
//                        currentEntry = Entry(startPos: Pos(row: row, column: col), direction: direction)
//                    }
//                } else {
//                    if cell.isActive {
//                        currentEntry?.increaseLength()
//                    } else {
//                        if currentEntry!.length > 1 {
//                            entries.append(currentEntry!)
//                        }
//                        currentEntry = nil
//                    }
//                }
//            }
//
//            if let entry = currentEntry, entry.length > 1 {
//                entries.append(entry)
//            }
//            currentEntry = nil
//        }
//
//        return entries
//    }
//
//
//
////    static func findAcroosEntries(_ crossword:Crossword) -> [Entry] {
////        var entries:[Entry] = []
////
////        var currentEntry:Entry? = nil
////
////        // Find all across clues
////        for row in 0..<crossword.rows {
////            for col in 0..<crossword.columns {
////                let cell = crossword[row,col]
////
////                if currentEntry == nil {
////                    if cell.isActive {
////                        currentEntry = Entry(startPos: Pos(row: row, column: col), direction: .across)
////                    }
////                } else {
////                    if cell.isActive {
////                        currentEntry?.increaseLength()
////                    }
////                    else {
////                        if currentEntry!.length > 1 {
////                            entries.append(currentEntry!)
////                        }
////                        currentEntry = nil
////                    }
////                }
////            }
////            if currentEntry != nil {
////                if currentEntry!.length > 1 {
////                    entries.append(currentEntry!)
////                }
////                currentEntry = nil
////            }
////        }
////
////        return entries
////    }
////
////    static func findDownEntries(_ crossword:Crossword) -> [Entry] {
////        var entries:[Entry] = []
////
////        var currentEntry:Entry? = nil
////
////        // Find all across clues
////        for col in 0..<crossword.columns {
////            for row in 0..<crossword.rows {
////                let cell = crossword[row,col]
////
////                if currentEntry == nil {
////                    if cell.isActive {
////                        currentEntry = Entry(startPos: Pos(row: row, column: col), direction: .down)
////                    }
////                } else {
////                    if cell.isActive {
////                        currentEntry?.increaseLength()
////                    }
////                    else {
////                        if currentEntry!.length > 1 {
////                            entries.append(currentEntry!)
////                        }
////                        currentEntry = nil
////                    }
////                }
////            }
////            if currentEntry != nil {
////                if currentEntry!.length > 1 {
////                    entries.append(currentEntry!)
////                }
////                currentEntry = nil
////            }
////        }
////
////        return entries
////    }
//}
