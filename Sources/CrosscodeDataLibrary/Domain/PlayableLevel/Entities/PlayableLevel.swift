import Foundation

public struct PlayableLevel: Level, Identifiable, Equatable, Hashable, Sendable {
    public var id: UUID { layout.id }
    public var layout: LevelLayout
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
    
    public var attemptedLetters: [Character]
    public var packId: UUID?
    public var isLocked: Bool


    
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
        self.layout = LevelLayout(id: id, number: number, gridText: gridText, letterMap: letterMap)
        
        self.packId = packId
        self.isLocked = false
        
        if let attemptedLetters {
            self.attemptedLetters = Array(attemptedLetters)
        } else {
            self.attemptedLetters = []
        }
    }
    


    public init(layout: LevelLayout, attemptedLetters: [Character] = [], packId: UUID? = nil, isLocked: Bool = false) {
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

extension PlayableLevel: Codable {
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
        layout = try container.decode(LevelLayout.self, forKey: .layout)
        let attemptedLettersString = try container.decode(String.self, forKey: .attemptedLetters)
        attemptedLetters = Array(attemptedLettersString)
        packId = try container.decodeIfPresent(UUID.self, forKey: .packId)
        isLocked = try container.decode(Bool.self, forKey: .isLocked)
    }
    
    public static var api: LevelsAPI { get {
        fatalError("\(#function) not implemented")
//        @Injected(\.layoutsAPI) var api
//        return api
    }}

}
