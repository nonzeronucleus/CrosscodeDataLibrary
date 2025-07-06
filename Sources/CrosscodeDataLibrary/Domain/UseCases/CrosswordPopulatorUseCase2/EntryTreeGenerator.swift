class EntryTreeGenerator {
    var acrossEntries: [Entry]
    var downEntries: [Entry]
    var root:Entry?
    var capturedEntries: [Entry] = []

    
    init(acrossEntries: [Entry], downEntries: [Entry]) {
        self.acrossEntries = acrossEntries
        self.downEntries = downEntries
        
        root = generateRoot()
    }
    
    
    func generateRoot() -> Entry {
        guard let rootEntry = self.downEntries.randomElement() else { fatalError("\(#function) not implemented") }
        
        downEntries.remove(rootEntry)
        
        return populateEntry(entry: rootEntry)
    }
    
    func populateEntry( entry: Entry) -> Entry {
        if entry.direction == .across {
            acrossEntries.remove(entry)
            for e in downEntries {
                if !downEntries.contains(e) { continue } // Check to see if entry has been removed by nested node since this loop started
                if entry.overlaps(other: e) {
                    downEntries.remove(e)
                    let newEntry = populateEntry(entry: e)
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
                    let newEntry = populateEntry(entry: e)
                    entry.linkEntry(to: newEntry)
                }
            }
        }
        
        return entry
    }
}
