import Foundation

public struct Layout: Identifiable, Equatable, Hashable, Sendable, Codable {
    public var id: UUID
    public var number: Int?
    public var crossword: Crossword
    public var letterMap: CharacterIntMap?

    public init(id: UUID, number: Int?, crossword: Crossword, letterMap: CharacterIntMap?) {
        self.id = id
        self.number = number
        self.crossword = crossword
        self.letterMap = letterMap
    }

    public var gridText: String? {
        Layout.transformedValue(crossword)
    }
    
    static func transformedValue(_ value: Any?) -> String? {
        let crossword = value as! Crossword
        var result = ""

        for row in 0..<crossword.rows {
            for column in 0..<crossword.columns {
                result += String(crossword[row, column].letter ?? ".")
            }
            result += "|"
        }

        return result
    }

    public var letterMapStr: String? {
        letterMap?.toJSON()
    }
}

public struct Level: Identifiable, Equatable, Hashable, Sendable {
    public var id: UUID { layout.id }
    public var layout: Layout
    public var attemptedLetters: [Character]
    public var packId: UUID?
    public var isLocked: Bool
    public var crossword: Crossword {
        get { layout.crossword }
        set { layout.crossword = newValue}
    }
    
    public var letterMap: CharacterIntMap? {
        get { layout.letterMap }
        set { layout.letterMap = newValue }
    }
    
    public var number: Int? { layout.number }
    public var gridText: String? { layout.gridText }
    public var letterMapStr: String? { layout.letterMapStr }

    
    var isCompleted: Bool {
        attemptedLetters.count == 26
    }
    
    // Primary initializer (matches original `Level` init)
    public init(
        id: UUID,
        number: Int?,
        packId: UUID?,
        gridText: String? = nil,
        letterMap: String? = nil,
        attemptedLetters: String? = nil
    ) {
        let crossword: Crossword
        if let gridText {
            crossword = Crossword(initString: gridText)
        } else {
            crossword = Crossword(rows: 15, columns: 15)
        }
        
        let parsedLetterMap = letterMap.map { CharacterIntMap(from: $0) }
        self.layout = Layout(id: id, number: number, crossword: crossword, letterMap: parsedLetterMap)
        
        self.packId = packId
        self.isLocked = false
        
        if let attemptedLetters {
            self.attemptedLetters = Array(attemptedLetters)
        } else {
            self.attemptedLetters = []
        }
    }
    


    public init(layout: Layout, attemptedLetters: [Character] = [], packId: UUID? = nil, isLocked: Bool = false) {
        self.layout = layout
        self.attemptedLetters = attemptedLetters
        self.packId = packId
        self.isLocked = isLocked
    }

    public var name: String {
        if let number = layout.number {
            return "Level \(number)"
        }
        return "Level \(layout.id.uuidString), \(attemptedLettersStr)"
    }

    var attemptedLettersStr: String {
        String(attemptedLetters)
    }
    
    var numCorrectLetters: Int {
        layout.letterMap?.countCorrectlyPlacedLetters(in: String(attemptedLetters)) ?? -1
    }

    func getNextLetterToReveal() -> Character? {
        layout.letterMap?.first(where: { !usedLetters.contains($0.key) })?.key
    }

    var usedLetters: Set<Character> {
        Set(attemptedLetters.filter { $0 != " " })
    }

    public func getDuplicateWords() -> [LevelWord] {
        let words = getWords().sorted { $0.word < $1.word }
        var duplicateWords: [LevelWord] = []

        for index in words.indices where index + 1 < words.count {
            if words[index + 1].word == words[index].word {
                duplicateWords.append(contentsOf: [words[index], words[index + 1]])
            }
        }
        return duplicateWords
    }

    func getWords() -> [LevelWord] {
        var words: [LevelWord] = []
        
        for row in 0..<layout.crossword.rows {
            var foundWord: LevelWord? = nil
            for column in 0..<layout.crossword.columns {
                let letter = layout.crossword[row, column].letter
                if foundWord == nil { foundWord = LevelWord(row: row, column: column, direction: .across) }
                if let letter { foundWord?.append(char: letter) }
                else if foundWord?.count ?? 0 > 1 { words.append(foundWord!) }
                foundWord = nil
            }
            if let foundWord, foundWord.count > 1 { words.append(foundWord) }
        }

        for column in 0..<layout.crossword.columns {
            var foundWord: LevelWord? = nil
            for row in 0..<layout.crossword.rows {
                let letter = layout.crossword[row, column].letter
                if foundWord == nil { foundWord = LevelWord(row: row, column: column, direction: .down) }
                if let letter { foundWord?.append(char: letter) }
                else if foundWord?.count ?? 0 > 1 { words.append(foundWord!) }
                foundWord = nil
            }
            if let foundWord, foundWord.count > 1 { words.append(foundWord) }
        }

        return words
    }
}

extension Level: Codable {
    private enum CodingKeys: String, CodingKey {
        case layout, attemptedLetters, packId, isLocked
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(layout, forKey: .layout)
        try container.encode(String(attemptedLetters), forKey: .attemptedLetters)
        try container.encode(packId, forKey: .packId)
        try container.encode(isLocked, forKey: .isLocked)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        layout = try container.decode(Layout.self, forKey: .layout)
        let attemptedLettersString = try container.decode(String.self, forKey: .attemptedLetters)
        attemptedLetters = Array(attemptedLettersString)
        packId = try container.decodeIfPresent(UUID.self, forKey: .packId)
        isLocked = try container.decode(Bool.self, forKey: .isLocked)
    }
}





//import Foundation
//
//
//
//public struct Level: Identifiable, Equatable, Hashable, Sendable {
//    public var id: UUID
//    
//    public var number: Int?
//    public var crossword: Crossword
//    public var letterMap: CharacterIntMap?
//    public var attemptedLetters: [Character]
//    public var packId: UUID?
//    var isCompleted: Bool {
//        attemptedLetters.count == 26
//    }
//    public var isLocked = false
//    
//    init(oldLevel:Level, crossword:Crossword, letterMap:CharacterIntMap?) {
//        id = oldLevel.id
//        number = oldLevel.number
//        packId = oldLevel.packId
//        self.crossword = crossword
//        self.letterMap = letterMap
//        attemptedLetters = oldLevel.attemptedLetters
//    }
//
//    
//    
//    public init(id: UUID, number: Int?, packId:UUID?, gridText: String? = nil, letterMap: String? = nil, attemptedLetters: String? = nil, numCorrectLetters: Int = 0) {
//        self.id = id
//        self.number = number
//        self.packId = packId
//        
//        if let gridText = gridText {
//            crossword = Crossword(initString: gridText)
//        }
//        else {
//            self.crossword = Crossword(rows: 15, columns: 15)
//        }
//
//        if let letterMap = letterMap {
//            self.letterMap = CharacterIntMap(from: letterMap)
//        }
//        
//        if let attemptedLetters {
//            self.attemptedLetters = Array(attemptedLetters)
//        } else {
//            self.attemptedLetters = []
//        }
//    }
//    
//    
//    public var name: String {
//        if let number = number {
//            return "Level \(number) "
//        }
//        return "Level \(id.uuidString), \(attemptedLettersStr)"
//    }
//
//    var gridText: String? {
//        get {
//            return Level.transformedValue(crossword)
//        }
//    }
//    
//    var letterMapStr: String? {
//        get {
//            guard let letterMap else { return nil }
//            return letterMap.toJSON()
//        }
//    }
//    
//    var attemptedLettersStr: String {
//        get {
//            return String(attemptedLetters)
//        }
//    }
//    
//    
//    var numCorrectLetters: Int {
//        get {
//            guard let letterMap else { return -1}
//            
//            return letterMap.countCorrectlyPlacedLetters(in: String(attemptedLetters))
//        }
//    }
//    
//    func getNextLetterToReveal() -> Character? {
//        guard let letterMap = letterMap else {
//            return nil
//        }
//        
//        for mappedLetter in letterMap {
//            if !usedLetters.contains(mappedLetter.key) {
//                return mappedLetter.key
//            }
//        }
//        
//        return nil
//    }
//    
//    var usedLetters: Set<Character> {
//        Set(attemptedLetters.filter { $0 != " " })
//    }
//    
//    public func getDuplicateWords() -> [LevelWord] {
//        let words = getWords().sorted { $0.word < $1.word }
//        var duplicateWords: [LevelWord] = []
//        
//        for index in words.indices {
//            let word = words[index]
//            guard index+1 < words.count else { continue }
//            let nextWord = words[index+1]
//            
//            if nextWord.word == word.word {
//                duplicateWords.append(word)
//                duplicateWords.append(nextWord)
//            }
//        }
//        return duplicateWords
//    }
//    
//    func getWords() -> [LevelWord] {
//        var words: [LevelWord] = []
//        
//        for row in 0..<crossword.rows {
//            var foundWord: LevelWord? = nil
//            for column in 0..<crossword.columns {
//                let letter = crossword[row, column].letter
//                
//                if foundWord == nil {
//                    foundWord = LevelWord(row:row, column:column, direction: .across)
//                }
//                if let letter {
//                    foundWord!.append(char: letter)
//                }
//                else {
//                    if foundWord!.count > 1 {
//                        words.append(foundWord!)
//                    }
//                    foundWord = nil
//                }
//            }
//            if let foundWord {
//                if foundWord.count > 1 {
//                    words.append(foundWord)
//                }
//            }
//        }
//        
//        
//        for column in 0..<crossword.columns {
//            var foundWord: LevelWord? = nil
//            for row in 0..<crossword.rows {
//                let letter = crossword[row, column].letter
//                
//                if foundWord == nil {
//                    foundWord = LevelWord(row:row, column:column, direction: .down)
//                }
//                if let letter {
//                    foundWord!.append(char: letter)
//                }
//                else {
//                    if foundWord!.count > 1 {
//                        words.append(foundWord!)
//                    }
//                    foundWord = nil
//                }
//            }
//            if let foundWord {
//                if foundWord.count > 1 {
//                    words.append(foundWord)
//                }
//            }
//        }
//
//        
//        return words
//    }
//}
//
//extension Level {
//    public static func == (lhs: Level, rhs: Level) -> Bool {
//        let eq = lhs.id == rhs.id && lhs.attemptedLetters == rhs.attemptedLetters && lhs.letterMap == rhs.letterMap
//        
//        return eq
//    }
//    
//    static func transformedValue(_ value: Any?) -> String? {
//        let crossword = value as! Crossword
//        var result = ""
//        
//        for row in 0..<crossword.rows {
//            for column in 0..<crossword.columns {
//                result += String(crossword[row, column].letter ?? ".")
//            }
//            result += "|"
//        }
//        
//        return result
//    }
//}
//
//
//extension Level:@retroactive Codable {
//    // CodingKeys to customize serialization
//    private enum CodingKeys: String, CodingKey {
//        case id, number, crossword, letterMap, attemptedLetters, packId, isLocked
//    }
//    
//    // Custom encoding
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(number, forKey: .number)
//        try container.encode(crossword, forKey: .crossword)
//        
//        // Encode letterMap as its string representation
//        if let letterMap = letterMap {
//            try container.encode(letterMap.toJSON(), forKey: .letterMap)
//        }
//        
//        // Encode attemptedLetters as string
//        try container.encode(String(attemptedLetters), forKey: .attemptedLetters)
//        try container.encode(packId, forKey: .packId)
//        try container.encode(isLocked, forKey: .isLocked)
//    }
//    
//    // Custom decoding
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(UUID.self, forKey: .id)
//        number = try container.decodeIfPresent(Int.self, forKey: .number)
//        crossword = try container.decode(Crossword.self, forKey: .crossword)
//        
//        // Decode letterMap from string
//        if let letterMapString = try container.decodeIfPresent(String.self, forKey: .letterMap) {
//            letterMap = CharacterIntMap(from: letterMapString)
//        } else {
//            letterMap = nil
//        }
//        
//        // Decode attemptedLetters from string
//        let attemptedLettersString = try container.decode(String.self, forKey: .attemptedLetters)
//        attemptedLetters = Array(attemptedLettersString)
//        
//        packId = try container.decodeIfPresent(UUID.self, forKey: .packId)
//        isLocked = try container.decode(Bool.self, forKey: .isLocked)
//    }
//}
//
//
