struct CrosswordPopulator{
    let acrossEntries: [Entry]
    let downEntries: [Entry]
    var crossword: Crossword
    let wordlist = WordListContainer()
    var alphabetByFrequency = "JQZXFVWBKHMYPCUGILNORSTADE"
    var lettersToFind:[Character] = []
    var failedMasks:[String] = []
    var totalAttempts:Int = 0
    let initCrossword:Crossword
    var usedWords: [String] = []
    var currentTask: PopulationTask

    init(crossword: Crossword, currentTask: PopulationTask) {
        self.crossword = crossword
        self.initCrossword = crossword
        self.acrossEntries = self.crossword.acrossEntries
        self.downEntries = self.crossword.downEntries
        self.currentTask = currentTask
    }

    mutating func populateCrossword() async throws -> (crossword: Crossword, letterMap: [Character]){    ///*, characterIntMap: CharacterIntMap*/) {
        var populated = false
        var attempts = 0
        let maxAttempts = 100
        
        totalAttempts = 0
        
        resetLettersToFind()
        
        while !populated && attempts < maxAttempts {
            let entryTreeGenerator = EntryTreeGenerator(acrossEntries: acrossEntries, downEntries: downEntries)
            let rootEntry = entryTreeGenerator.generateRoot()


            do {
                crossword = initCrossword
                totalAttempts = 0
                usedWords = []
                populated = try await populateEntry(rootEntry)
                
                if populated {
                    upateLettersWithFoundWords()
                    
                    if lettersToFind.count > 0 {
                        populated = false
                    }
                }
            }
            catch PopulationError.tooManyTotalAttempts {
                populated = false
            }
            debugPrint(attempts)
            attempts += 1
        }
        
        if attempts >= maxAttempts {
            throw PopulationError.failedToPopulate(reason: "Had \(attempts) attempts")
        }
        
        guard
            let start = "A".unicodeScalars.first?.value,
            let end = "Z".unicodeScalars.first?.value
        else {
            fatalError("Couldn't get Unicode scalar values for A or Z")
        }
        let alphabet = (start...end).map { Character(UnicodeScalar($0)!) }.shuffled()
        
        return (crossword: crossword, letterMap: alphabet/*characterIntMap: CharacterIntMap(shuffle: true)*/)
    }
    
    private mutating func populateEntry(_ entry: Entry) async throws -> Bool {
        var allPopulated = false
        var attemptCount = 0

        while !allPopulated {
            totalAttempts += 1
            
            if totalAttempts > 600 {
                throw PopulationError.tooManyTotalAttempts(attempts: totalAttempts)
            }
            
            if currentTask.isCancelled {
                throw PopulationError.cancelled
            }


            let currentCrossword = crossword
            let currentUsedWords = usedWords
            let mask = crossword.getWord(entry: entry)
            
            if failedMasks.contains(mask) {
                return false
            }

            let wordsByLength = wordlist.getWordsByLength(length: mask.count)
            var matchingWords = wordsByLength.filterByMask(mask: mask)
            
            let wordsInCrossword = crossword.getWords(length: mask.count)
            
            for existingWord in wordsInCrossword {
                matchingWords.remove(existingWord)
            }
            
            if matchingWords.isEmpty {
                return false
            }
            
            
            var finalWordList: [String] = []
            var tempLetters = lettersToFind

            while finalWordList.isEmpty && !tempLetters.isEmpty && !Task.isCancelled {
                let letter = tempLetters.removeFirst()
                finalWordList = matchingWords.filterContaining(letter: letter)
                let usedWordsSet = Set(usedWords)
                finalWordList = finalWordList.filter { !usedWordsSet.contains($0) }
            }

            if finalWordList.isEmpty {
                finalWordList = matchingWords
            }


            guard let word = finalWordList.randomElement() else {
                crossword = currentCrossword
                usedWords = currentUsedWords
                failedMasks.append(mask)
                
                return false
            }
            
            usedWords.append(word)
            
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
                attemptCount += 1
                if attemptCount >= 5 {
                    crossword = currentCrossword
                    usedWords = currentUsedWords

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

public enum PopulationError: Error, CustomStringConvertible, LocalizedError {
    case tooManyTotalAttempts(attempts: Int)  // Fixed typo in parameter name
    case cancelled
    case failedToPopulate(reason: String)
    
    public var description: String {
        switch self {
            case .tooManyTotalAttempts(let attempts):
                return "Population failed after \(attempts) attempts"
            case .failedToPopulate(let reason):
                return "Population failed: \(reason)"
            case .cancelled:
                return "Canceled population"
        }
    }
    
    // LocalizedError conformance for better UIKit/SwiftUI integration
    public var errorDescription: String? {
        return description
    }
    
    public var failureReason: String? {
        switch self {
            case .tooManyTotalAttempts: return "Maximum attempt limit reached"
            case .failedToPopulate: return "Population algorithm failed"
            case .cancelled: return description
                
        }
    }
    
    public var recoverySuggestion: String? {
        return "Please try again with different parameters"
    }
}
