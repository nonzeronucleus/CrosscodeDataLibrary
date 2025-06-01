//
//  LevelWord.swift
//  CrosscodeDataLibrary
//
//  Created by Ian Plumb on 19/05/2025.
//


public class LevelWord: CustomStringConvertible {
    var position: (row: Int, column: Int)
    var direction: Direction
    var word: String = ""
    
    init(row: Int, column: Int, direction: Direction) {
        self.position = (row:row, column:column)
        self.direction = direction
        self.word = ""
    }
    
    func append(char:Character) {
        word.append(char)
    }
    
    var count: Int {
        return word.count
    }
    
    public var description: String {
        return "\(position): \(direction): \(word)"
    }
}
