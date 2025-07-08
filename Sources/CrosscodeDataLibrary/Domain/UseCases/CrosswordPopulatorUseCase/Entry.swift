import Foundation

class Entry:InstanceEquatable, CustomStringConvertible {
    let id: UUID = UUID()
    private(set) var startPos:  Pos
    private(set) var length: Int
    private(set) var direction: Direction
    private(set) var linkedEntries: [Entry] = []
    var depth = 0
    var attemptCount = 0 

    var word:String?
    
//    static func == (lhs: Entry, rhs: Entry) -> Bool {
//        return lhs.startPos == rhs.startPos && lhs.direction == rhs.direction && lhs.length == rhs.length
//    }
//    
    
    
    init (startPos:Pos, length:Int = 1, direction:Direction) {
        self.startPos = startPos
        self.length = length
        self.direction = direction
    }
    
//    convenience init(startPos:Pos, direction:Direction) {
//        self.init(startPos:startPos, length:1, direction:direction)
//    }
//    
    func increaseLength() {
        length += 1
    }
    
    func reset() {
        linkedEntries = []
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
    
    func linkEntry(to otherEntry:Entry) {
        linkedEntries.append(otherEntry)
    }
    
    // Does this entry overlap the other review
//    func overlaps(other: Entry) -> Bool {
//        guard direction != other.direction else { return false } // If going the same direction, it can't overlap
//        
//        if startPos.column <= other.startPos.column && startPos.column + length >= other.startPos.column {
//            if startPos.column <= other.startPos.column && startPos.column + length >= other.startPos.column {
//            }
//        }
//    }
    
    
    func overlaps(other: Entry) -> Bool {
        guard (direction != other.direction) else { return false }
        
        let horiz = self.direction == .across ? self : other
        let vert = self.direction == .down ? self : other
        let horizStart = horiz.startPos
        let vertStart = vert.startPos
            
        // Check for overlap
        return (horizStart.column...horizStart.column+horiz.length-1).contains(vertStart.column) && (vertStart.row...vertStart.row+vert.length-1).contains(horizStart.row)
    }
    
    func debug(tab:Int = 0) {
        let spaced = String(repeating: "--", count: tab*2)
        
        debugPrint("\(id) \(spaced)\(depth)")
        
        for linkedEntry in linkedEntries {
            linkedEntry.debug(tab: tab + 1)
        }
    }
}

