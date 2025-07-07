struct CrosswordPopulator{
    let acrossEntries: [Entry]
    let downEntries: [Entry]
    var crossword: Crossword
//    let rootEntry: Entry
    let wordlist = WordListContainer()


    init(crossword: Crossword) {
        self.crossword = crossword
        self.acrossEntries = crossword.findEntries(direction: .across)
        self.downEntries = crossword.findEntries(direction: .down)
    }

    mutating func populateCrossword(currentTask: PopulationTask?) async throws -> (crossword: Crossword, characterIntMap: CharacterIntMap) {
        let entryTreeGenerator = EntryTreeGenerator(acrossEntries: acrossEntries, downEntries: downEntries)
        let rootEntry = entryTreeGenerator.generateRoot()
        
        var populated = false
        var attempts = 0
        
        while !populated && attempts < 1 {
            populated = try await populateEntry(rootEntry)
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

            var wordsByLength = wordlist.getWordsByLength(length: mask.count)
            var matchingWords = wordsByLength.filterByMask(mask: mask)

            if matchingWords.isEmpty {
                wordlist.reset(forLength: mask.count)
                wordsByLength = wordlist.getWordsByLength(length: mask.count)
                matchingWords = wordsByLength.filterByMask(mask: mask)
            }

            guard let word = matchingWords.randomElement() else {
                crossword = currentCrossword

                return false
            }

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

}
