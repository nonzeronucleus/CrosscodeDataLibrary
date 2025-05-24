import Foundation
import Factory

public struct Cell: Equatable, Identifiable, Hashable, Codable, Grid2DItem, Sendable  {
    public let id: UUID
    let pos: Pos
    public var letter:Character?
    
    init(pos:Pos, letter:Character? = nil) {
        @Injected(\.uuid) var uuid
        
        self.id = uuid()
        self.letter = letter
        self.pos = pos
    }
    
    // Create cell based on a config, where the "." character represents a nil char
    // Primarily for testing purposes
    init(pos:Pos, configChar:Character ) {
        let letter = configChar == "." ? nil : configChar

        self.init(pos:pos, letter:letter)
    }
    
    mutating public func reset() {
        if letter != nil {
            letter = " "
        }
    }

    
    public mutating func toggle() {
        if letter == nil {
            letter = " "
        }
        else {
            letter = nil
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, letter, number, pos
    }
    
    public func toStorable() -> Character {
        return letter ?? "."
    }
    
    public var isActive: Bool {
        letter != nil
    }

    

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: Cell.CodingKeys.id)
        self.pos = try container.decode(Pos.self, forKey: .pos)
        if let letterString = try container.decodeIfPresent(String.self, forKey: .letter) {
            letter = letterString.first 
        } else {
            letter = nil
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(pos, forKey: .pos)
        try container.encode(letter.map { String($0) }, forKey: .letter)
    }
}
