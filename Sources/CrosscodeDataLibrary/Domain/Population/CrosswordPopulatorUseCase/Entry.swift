import Foundation

struct Entry: Equatable, CustomStringConvertible, Sendable, Hashable {
    let id: UUID = UUID()
    let startPos:  Pos
    let direction: Direction
    let linkedEntries: [Entry]
    let length: Int
    
    init (startPos:Pos, length:Int = 1, direction:Direction, linkedEntries:[Entry] = []) {
        self.startPos = startPos
        self.length = length
        self.direction = direction
        self.linkedEntries = linkedEntries
    }
    
    var description: String {
        var str = "Entry: startPos: \(startPos), length: \(length), direction: \(direction)"
        
        for linkedEntry in linkedEntries {
            str += "\n\tlinkedEntry: \(linkedEntry.startPos), \(linkedEntry.direction)"
        }
        
        return str
    }
    
    func isInSamePos(as otherEntry:Entry) -> Bool {
        startPos == otherEntry.startPos && direction == otherEntry.direction && length == otherEntry.length
    }
    
    func overlaps(other: Entry) -> Bool {
        guard (direction != other.direction) else { return false }
        
        let horiz = self.direction == .across ? self : other
        let vert = self.direction == .down ? self : other
        let horizStart = horiz.startPos
        let vertStart = vert.startPos
            
        // Check for overlap
        return (horizStart.column...horizStart.column+horiz.length-1).contains(vertStart.column) && (vertStart.row...vertStart.row+vert.length-1).contains(horizStart.row)
    }
}

