class EntryTreeGenerator {
    var acrossEntries: [Entry]
    var downEntries: [Entry]
    
    init(acrossEntries: [Entry], downEntries: [Entry]) {
        self.acrossEntries = acrossEntries
        self.downEntries = downEntries
    }
    
    
    func generateRoot() -> Entry {
        let rootEntry = self.downEntries.randomElement()
        guard let rootEntry else { fatalError("\(#function) not implemented") }
        
        downEntries.remove(rootEntry)
        
        return generateEntry(entry: rootEntry, depth: 0)
    }
    
    private func generateEntry( entry: Entry, depth:Int) -> Entry {
        entry.depth = depth
        
        if entry.direction == .across {
            acrossEntries.remove(entry)
            for e in downEntries {
                if !downEntries.contains(e) { continue } // Check to see if entry has been removed by nested node since this loop started
                if entry.overlaps(other: e) {
                    downEntries.remove(e)
                    let newEntry = generateEntry(entry: e, depth: depth+1)
                    entry.linkEntry(to: newEntry)
                }
            }
        }
        
        if entry.direction == .down {
            downEntries.remove(entry)

            for e in acrossEntries {
                if !acrossEntries.contains(e) { continue } // Check to see if entry has been removed by nested node since this loop started

                if entry.overlaps(other: e) {
                    acrossEntries.remove(e)
                    let newEntry = generateEntry(entry: e, depth: depth+1)
                    entry.linkEntry(to: newEntry)
                }
            }
        }
        
        return entry
    }
}
