class EntryTreeGenerator {
    var acrossEntries: [Entry]
    var downEntries: [Entry]
    
    init(acrossEntries: [Entry], downEntries: [Entry]) {
        self.acrossEntries = acrossEntries
        self.downEntries = downEntries
    }
    
    
    func generateRoot() -> Entry {
        acrossEntries = acrossEntries.map { entry in Entry(startPos: entry.startPos, length: entry.length, direction: entry.direction) }
        downEntries = downEntries.map { entry in Entry(startPos: entry.startPos, length: entry.length, direction: entry.direction) }

//        for e in acrossEntries {
//            e.reset()
//        }
//        for e in downEntries {
//            e.reset()
//        }

        let rootEntry = self.downEntries.randomElement()
        guard let rootEntry else {
            fatalError("\(#function) not implemented")
        }
        
        downEntries.remove(rootEntry)
        
        return generateEntry(entry: rootEntry)
    }
    
    private func generateEntry( entry: Entry) -> Entry {
        var childEntries:[Entry] = []
        
        if entry.direction == .across {
            acrossEntries.remove(entry)
            for e in downEntries {
                if !downEntries.contains(e) { continue } // Check to see if entry has been removed by nested node since this loop started
                if entry.overlaps(other: e) {
                    downEntries.remove(e)
                    let newEntry = generateEntry(entry: e)
                    childEntries.append(newEntry)
//                    entry.linkEntry(to: newEntry)
                }
            }
        }
        
        if entry.direction == .down {
            downEntries.remove(entry)

            for e in acrossEntries {
                if !acrossEntries.contains(e) { continue } // Check to see if entry has been removed by nested node since this loop started

                if entry.overlaps(other: e) {
                    acrossEntries.remove(e)
                    let newEntry = generateEntry(entry: e)
                    childEntries.append(newEntry)

//                    entry.linkEntry(to: newEntry)
                }
            }
        }
        return Entry(startPos: entry.startPos, length: entry.length, direction: entry.direction, linkedEntries: childEntries)
    }
}
