struct CrosswordPopulator2 {
    let acrossEntries: [Entry]
    let downEntries: [Entry]
    let crossword: Crossword
    
    init(crossword: Crossword) {
        self.crossword = crossword
        self.acrossEntries = Self.findAcroosEntries(crossword)
        self.downEntries = Self.findDownEntries(crossword)
        
        let _ = EntryTreeGenerator(acrossEntries: acrossEntries, downEntries: downEntries)
    }
    
    func populateCrossword(currentTask: PopulationTask?) async throws -> (crossword: Crossword, characterIntMap: CharacterIntMap) {
        return (crossword: crossword, characterIntMap: CharacterIntMap(shuffle: true))
    }
}


extension CrosswordPopulator2 {
    static func findAcroosEntries(_ crossword:Crossword) -> [Entry] {
        var entries:[Entry] = []
        
        var currentEntry:Entry? = nil

        // Find all across clues
        for row in 0..<crossword.rows {
            for col in 0..<crossword.columns {
                let cell = crossword[row,col]
                
                if currentEntry == nil {
                    if cell.isActive {
                        currentEntry = Entry(startPos: Pos(row: row, column: col), direction: .across)
                    }
                } else {
                    if cell.isActive {
                        currentEntry?.increaseLength()
                    }
                    else {
                        if currentEntry!.length > 1 {
                            entries.append(currentEntry!)
                        }
                        currentEntry = nil
                    }
                }
            }
            if currentEntry != nil {
                if currentEntry!.length > 1 {
                    entries.append(currentEntry!)
                }
                currentEntry = nil
            }
        }
        
        return entries
    }
    
    static func findDownEntries(_ crossword:Crossword) -> [Entry] {
        var entries:[Entry] = []
        
        var currentEntry:Entry? = nil

        // Find all across clues
        for col in 0..<crossword.columns {
            for row in 0..<crossword.rows {
                let cell = crossword[row,col]
                
                if currentEntry == nil {
                    if cell.isActive {
                        currentEntry = Entry(startPos: Pos(row: row, column: col), direction: .down)
                    }
                } else {
                    if cell.isActive {
                        currentEntry?.increaseLength()
                    }
                    else {
                        if currentEntry!.length > 1 {
                            entries.append(currentEntry!)
                        }
                        currentEntry = nil
                    }
                }
            }
            if currentEntry != nil {
                if currentEntry!.length > 1 {
                    entries.append(currentEntry!)
                }
                currentEntry = nil
            }
        }
        
        return entries
    }
}
