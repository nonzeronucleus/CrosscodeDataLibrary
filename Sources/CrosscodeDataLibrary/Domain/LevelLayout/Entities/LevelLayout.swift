import Foundation
import Factory

public struct LevelLayout: Level, Identifiable, Equatable, Hashable, Sendable, Codable {
    public var name: String { get { "Level \(number ?? 0)"}}
    
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
    
    public init(id: UUID, number: Int?, gridText: String?, letterMap: String? = nil) {
        self.id = id
        self.number = number
        if let gridText {
            crossword = Crossword(initString: gridText)
        } else {
            crossword = Crossword(rows: 15, columns: 15)
        }
        let parsedLetterMap = letterMap.map { CharacterIntMap(from: $0) }

        self.letterMap = parsedLetterMap
    }


    public var gridText: String? {
        LevelLayout.transformedValue(crossword)
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

extension LevelLayout {
    private enum CodingKeys: String, CodingKey {
        case id, number, crossword, letterMap
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        number = try container.decodeIfPresent(Int.self, forKey: .number)
        
        // Decode crossword from the string representation
        let crosswordString = try container.decode(String.self, forKey: .crossword)
        crossword = Crossword(initString: crosswordString)
        
        // Decode letterMap if present
        if let letterMapString = try container.decodeIfPresent(String.self, forKey: .letterMap) {
            letterMap = CharacterIntMap(from: letterMapString)
        } else {
            letterMap = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(number, forKey: .number)
        try container.encode(crossword.layoutString(), forKey: .crossword)
        try container.encodeIfPresent(letterMap?.toJSON(), forKey: .letterMap)
    }

    
//    static var api: LevelsAPI { get {
    public static func getApi() -> APIType {
        return .layoutsAPI
    }
}
