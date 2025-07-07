//struct CrosswordPopulator{
//    let acrossEntries: [Entry]
//    let downEntries: [Entry]
//    var crossword: Crossword
//    let rootEntry: Entry
//    let wordlist = WordListContainer()
//
//    
//    init(crossword: Crossword) {
//        self.crossword = crossword
//        self.acrossEntries = crossword.findEntries(direction: .across)
//        self.downEntries = crossword.findEntries(direction: .down)
//        
//        let entryTreeGenerator = EntryTreeGenerator(acrossEntries: acrossEntries, downEntries: downEntries)
//        rootEntry = entryTreeGenerator.generateRoot()
//    }
//    
//    mutating func populateCrossword(currentTask: PopulationTask?) async throws -> (crossword: Crossword, characterIntMap: CharacterIntMap) {
//        try await populateEntry(rootEntry)
//        
//        return (crossword: crossword, characterIntMap: CharacterIntMap(shuffle: true))
//    }
//    
//    private mutating func populateEntry(_ entry: Entry) async throws {
////        let newEntry = Entry(startPos: entry.startPos, direction: entry.direction)
//        let mask = crossword.getWord(entry: entry)
//        
//        var wordsByLength = wordlist.getWordsByLength(length: mask.count)
//        var matchingWords = wordsByLength.filterByMask(mask: mask)
//
//        if matchingWords.isEmpty {
//            wordlist.reset(forLength: mask.count)
//            wordsByLength = wordlist.getWordsByLength(length: mask.count)
//            matchingWords = wordsByLength.filterByMask(mask: mask)
//        }
//        
//        if let word = matchingWords.randomElement() {
//            debugPrint("Found \(word) for \(mask)")
////            newEntry.word = word
//            crossword.setWord(entry: entry, word: word)
//        }
//        
//        for child in entry.linkedEntries {
//            try await populateEntry(child)
////            try await newEntry.linkEntry(to: populateEntry(child))
//        }
//        
////        return newEntry
//    }
//    
//}
