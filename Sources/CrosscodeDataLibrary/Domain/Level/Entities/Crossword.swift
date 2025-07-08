public typealias Crossword = Grid2D<Cell>

public extension Crossword {
//    func encode(to encoder: any Encoder) throws {
//        
//    }
//    
    init(rows: Int, columns: Int) {
        self.init(rows: rows, columns: columns, elementGenerator: { row, col in Cell(pos: Pos(row: row, column: col)) })
    }
    
    init(initString:String) {
        let initArray = initString.components(separatedBy: "|").filter { !$0.isEmpty }
        
        let rows = initArray.count
        let columns = initArray[0].count
        
        self.init(rows: rows, columns: columns) {
            row, col in
                return Cell(pos: Pos(row: row, column: col), configChar: initArray[row][col])
        }
    }
    
    mutating func reset() {
        for rowIndex in elements.indices {
            for colIndex in elements[rowIndex].indices {
                var elem = elements[rowIndex][colIndex]
                elem.reset()
                self[rowIndex,colIndex] = elem
            }
        }
    }
    
    var isPopulated: Bool {
        for element in self.listElements() {
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
                result += String(self[row, column].letter ?? ".")
            }
            result += "|"
        }
        
        return result
    }
    
    mutating func depopulate() {
        updateAll { cell in
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
        var entries: [Entry] = []
        var currentEntry: Entry?
        
        let outerRange = direction == .across ? 0..<rows : 0..<columns
        let innerRange = direction == .across ? 0..<columns : 0..<rows
        
        for outer in outerRange {
            for inner in innerRange {
                let row = direction == .across ? outer : inner
                let col = direction == .across ? inner : outer
                let cell = self[row, col]
                
                if currentEntry == nil {
                    if cell.isActive {
                        currentEntry = Entry(startPos: Pos(row: row, column: col), direction: direction)
                    }
                } else {
                    if cell.isActive {
                        currentEntry?.increaseLength()
                    } else {
                        if currentEntry!.length > 1 {
                            entries.append(currentEntry!)
                        }
                        currentEntry = nil
                    }
                }
            }
            
            if let entry = currentEntry, entry.length > 1 {
                entries.append(entry)
            }
            currentEntry = nil
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
            let cell = self[pos.row, pos.column]

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
        entry.word = word

        for i in 0...entry.length-1 {
            let index = word.index(word.startIndex, offsetBy: i)
            let char = word[index]
            self[entry.startPos.row + iter.0 * i, entry.startPos.column + iter.1 * i].letter = char
        }
    }
    
    func getUsedLetters() -> [Character]{
        var letters:Set<Character> = []
        for cell in listElements() {
            if let letter = cell.letter {
                letters.insert(letter)
//                removeLetter(letter: cell.letter!)
            }
        }
        
        return letters.sorted(by: <)
    }
}




