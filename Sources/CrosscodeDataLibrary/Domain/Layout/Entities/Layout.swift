import Foundation
import Factory

public struct Layout: Level, Identifiable, Equatable, Hashable, Sendable, Codable {
    public var name: String { get { "Level \(number ?? 0)"}}
    
    public var id: UUID
    public var number: Int?
    public var crossword: Crossword
    public var letterMap: [Character] = []


    // Only for tests
    public init(id: UUID, number: Int?, crossword: Crossword, letterMap: String) {
        self.id = id
        self.number = number
        self.crossword = crossword
        self.letterMap = Array(letterMap)
    }
    
    public init(id: UUID, number: Int?, gridText: String?, letterMap: String? = nil) {
        self.id = id
        self.number = number
        if let gridText {
            crossword = Crossword(initString: gridText)
        } else {
            crossword = Crossword(rows: 15, columns: 15)
        }
        
        if let letterMap {
            initLetterMap(letterMap: letterMap)
        }
    }
    
    public mutating func initLetterMap(letterMap: String) {
        if letterMap == "" { return }
        do {
            self.letterMap = try buildStringFromJSONMapping(letterMap)
        }
        catch(let e) {
            debugPrint(e.localizedDescription)
        }
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
        String(letterMap)
    }
}


func buildStringFromJSONMapping(_ jsonString: String) throws -> [Character] {
    if jsonString.count == 26 {
        return Array(jsonString.uppercased(with: .autoupdatingCurrent))
    }
    

    // 1. Parse JSON into dictionary
    guard let data = jsonString.data(using: .utf8),
          let dict = try JSONSerialization.jsonObject(with: data) as? [String: Int]
    else {
        throw NSError(domain: "Invalid JSON", code: 0)
    }
    
    // 2. Find maximum position value
    guard let maxPos = dict.values.max() else {
        return [] // Empty if no characters
    }
    
    // 3. Create array with placeholders
    var characters = [Character](repeating: " ", count: maxPos + 1)
    
    // 4. Place each character at its position
    for (charStr, position) in dict {
        guard let char = charStr.first, position >= 0 else { continue }
        if position < characters.count {
            characters[position] = char
        }
    }
    
    return characters
}

extension Layout {
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
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(number, forKey: .number)
        try container.encode(crossword.layoutString(), forKey: .crossword)
        fatalError("\(#function) not implemented")
    }

    
    public static func getApi() -> APIType {
        return .layoutsAPI
    }
}

extension Layout {
    public func withUpdatedCrossword(_ crossword: Crossword) -> Layout {
        var newLayout = self
        newLayout.crossword = crossword
        return newLayout
    }
}

