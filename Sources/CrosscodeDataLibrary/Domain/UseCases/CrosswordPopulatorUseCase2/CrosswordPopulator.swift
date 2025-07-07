struct CrosswordPopulator{
    let acrossEntries: [Entry]
    let downEntries: [Entry]
    var crossword: Crossword
    let wordlist = WordListContainer()
    var alphabetByFrequency = "JQZXFVWBKHMYPCUGILNORSTADE"
    var lettersToFind:[Character] = []
    var failedMasks:[String] = []

    init(crossword: Crossword) {
        self.crossword = crossword
        self.acrossEntries = crossword.findEntries(direction: .across)
        self.downEntries = crossword.findEntries(direction: .down)
    }

    mutating func populateCrossword(currentTask: PopulationTask?) async throws -> (crossword: Crossword, characterIntMap: CharacterIntMap) {
        var populated = false
        var attempts = 0
        
        resetLettersToFind()
        
        while !populated && attempts < 5 {
            let entryTreeGenerator = EntryTreeGenerator(acrossEntries: acrossEntries, downEntries: downEntries)
            let rootEntry = entryTreeGenerator.generateRoot()

            populated = try await populateEntry(rootEntry)
            
            if populated {
                upateLettersWithFoundWords()
                
                if lettersToFind.count > 0 {
                    populated = false
                }
            }
            
            attempts += 1
        }

        return (crossword: crossword, characterIntMap: CharacterIntMap(shuffle: true))
    }
    
    private mutating func populateEntry(_ entry: Entry) async throws -> Bool {
        var allPopulated = false
        entry.attemptCount = 0

        while !allPopulated {
            let currentCrossword = crossword
            let mask = crossword.getWord(entry: entry)
            
            if failedMasks.contains(mask) {
                return false
            }

            var wordsByLength = wordlist.getWordsByLength(length: mask.count)
            var matchingWords = wordsByLength.filterByMask(mask: mask)

            if matchingWords.isEmpty {
                wordlist.reset(forLength: mask.count)
                wordsByLength = wordlist.getWordsByLength(length: mask.count)
                matchingWords = wordsByLength.filterByMask(mask: mask)
            }
            
            
            var finalWordList: [String] = []
            var tempLetters = lettersToFind

            while finalWordList.isEmpty && !tempLetters.isEmpty && !Task.isCancelled {
                let letter = tempLetters.removeFirst()
                finalWordList = matchingWords.filterContaining(letter: letter)
            }

            if finalWordList.isEmpty {
                finalWordList = matchingWords
            }


            guard let word = finalWordList.randomElement() else {
                crossword = currentCrossword

                failedMasks.append(mask)
                
                return false
            }
            
            upateLettersWithFoundWords()
            
            

            crossword.setWord(entry: entry, word: word)

            var failedPopulation = false

            for child in entry.linkedEntries {
                guard try await populateEntry(child) else {
                    failedPopulation = true
                    break
                }
            }

            if !failedPopulation {
                allPopulated = true
            }
            else {
                crossword = currentCrossword
                entry.attemptCount += 1
                if entry.attemptCount >= 3 {
                    crossword = currentCrossword
                    return false
                }
            }
        }

        return true
    }

    private mutating func resetLettersToFind() {
        lettersToFind = Array(alphabetByFrequency)
    }
    
    mutating func upateLettersWithFoundWords() {
        resetLettersToFind()
        for cell in crossword.listElements() {
            if cell.letter != nil {
                removeLetter(letter: cell.letter!)
            }
        }
    }
    
    mutating func removeLetter(letter: Character) {
        if let index = lettersToFind.firstIndex(of: letter) {
            lettersToFind.remove(at: index)
        }
    }
}
