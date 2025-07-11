//public typealias Crossword = Grid2D<Cell>

public struct Crossword: Equatable, Hashable, Sendable {
    var grid:Grid2D<Cell>
    public var rows: Int { grid.rows }
    public var columns: Int { grid.columns }
    public var elements: [[Cell]] { grid.elements }
    var entries: [Direction:[Entry]] = [:]
    

    public init(rows: Int, columns: Int) {
        debugPrint("init(rows: Int, columns: Int)")

        grid = .init(rows: rows, columns: columns, elementGenerator: { row, col in Cell(pos: Pos(row: row, column: col)) })
    }
    
    public init(initString:String) {
        debugPrint("init(initString:String)")
        let initArray = initString.components(separatedBy: "|").filter { !$0.isEmpty }
        
        let rows = initArray.count
        let columns = initArray[0].count
        
        grid = .init(rows: rows, columns: columns) {
            row, col in
                return Cell(pos: Pos(row: row, column: col), configChar: initArray[row][col])
        }
    }
    
    mutating func reset() {
        for rowIndex in elements.indices {
            for colIndex in elements[rowIndex].indices {
                var elem = elements[rowIndex][colIndex]
                elem.reset()
                grid[rowIndex,colIndex] = elem
            }
        }
    }
    
    var isPopulated: Bool {
        for element in grid.listElements() {
            if element.letter == " " {
                return false
            }
        }
        return true
    }
    
    func layoutString() -> String {
        var result = ""
        
        for row in 0..<rows {
            for column in 0..<columns {
                result += String(grid[row, column].letter ?? ".")
            }
            result += "|"
        }
        
        return result
    }
    
    mutating func depopulate() {
        grid.updateAll { cell in
            if cell.letter != nil {
                var newCell = cell
                newCell.letter = " "
                return newCell
            } else {
                return cell
            }
        }
    }
    
    internal func findEntries(direction: Direction) -> [Entry] {
        debugPrint("FindEntries")
        var entries: [Entry] = []
//        var currentEntry: Entry?
        
        let outerRange = direction == .across ? 0..<rows : 0..<columns
        let innerRange = direction == .across ? 0..<columns : 0..<rows
        
        for outer in outerRange {
            var startPos: Pos?
            var length = 0
            for inner in innerRange {
                let row = direction == .across ? outer : inner
                let col = direction == .across ? inner : outer
                let cell = grid[row, col]
                
                if startPos == nil {
                    if cell.isActive {
                        startPos = Pos(row: row, column: col)
//                        currentEntry = Entry(startPos: Pos(row: row, column: col), direction: direction)
                    }
                } else {
                    if cell.isActive {
                        length += 1
                    } else {
                        if let startPos {
                            if length > 1 {
                                entries.append(Entry(startPos: startPos, length: length+1, direction: direction ))
                            }
                        }
                        
                        startPos = nil
                        length = 0
                    }
                }
            }
            
            if let startPos {
                if length > 1 {
                    entries.append(Entry(startPos: startPos, length: length+1, direction: direction ))
                }
            }
            
            startPos = nil
            length = 0
        }
        
        return entries
    }
    
    internal func getWord(entry:Entry) -> String {
        var word = ""
        if entry.length == 0 {
            return ""
        }

        let iter = entry.direction == .across ? (0,1) : (1,0)

        for i in 0...entry.length-1 {
            let pos = Pos(row:entry.startPos.row + iter.0 * i, column: entry.startPos.column + iter.1 * i)
            let cell = grid[pos.row, pos.column]

            if let char = cell.letter {
                word.append(char)
            }
        }

        return word
    }
    
    mutating internal func setWord(entry:Entry, word:String) {

        if entry.length == 0 {
            return
        }

        guard word.count == entry.length else { return }

        let iter = entry.direction == .across ? (0,1) : (1,0)

//        wordlist.removeWord(word: word)
//        entry.word = word

        for i in 0...entry.length-1 {
            let index = word.index(word.startIndex, offsetBy: i)
            let char = word[index]
            grid[entry.startPos.row + iter.0 * i, entry.startPos.column + iter.1 * i].letter = char
        }
    }
    
    func getUsedLetters() -> [Character]{
        var letters:Set<Character> = []
        for cell in grid.listElements() {
            if let letter = cell.letter {
                letters.insert(letter)
//                removeLetter(letter: cell.letter!)
            }
        }
        
        return letters.sorted(by: <)
    }
}


// Grid wrappers
extension Crossword {
    public subscript(row: Int, column: Int) -> Cell {
        get {
            grid[row, column]
        } set {
            grid[row, column] = newValue
        }
    }
    
    func listElements() -> [Cell] {
        grid.listElements()
    }
    
    public func locationOfElement(byID id: Cell.ID) -> Pos? {
        grid.locationOfElement(byID: id)
    }
    
    public mutating func mutateElements(_ transform: (inout [[Cell]]) -> Void) {
        var elements = grid.elements // Assuming you have elements access
        transform(&elements)
        grid.elements = elements
    }
    
    public mutating func updateElement(byID id: Cell.ID, with transform: (inout Cell) -> Void) -> Bool {
        grid.updateElement(byID: id, with: transform)
    }
    
    public mutating func updateElement(byPos location: Pos, with transform: (inout Cell) -> Void) {
        grid.updateElement(byPos: location, with: transform)
    }
    
    public func findElement(byID id: Cell.ID) -> Cell? {
        grid.findElement(byID: id)
    }
    
    public func getRows() -> [[Cell]] {
        grid.getRows()
    }
}





