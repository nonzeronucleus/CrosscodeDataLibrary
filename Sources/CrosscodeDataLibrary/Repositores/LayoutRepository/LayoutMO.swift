import CoreData

extension LayoutMO: LevelMO {
    public func populate(from level: any Level) {
        self.id = level.id
        self.number = Int64(level.number ?? 0)
//        self.packId = level.packId
        self.gridText = level.gridText
        self.letterMap = level.letterMapStr
//        self.attemptedLetters = level.attemptedLettersStr
//        self.numCorrectLetters = Int16(level.numCorrectLetters)
    }
    
    public func toLevel() -> any Level {
        guard let id = self.id else {
            fatalError("Missing id for LevelMO number \(self.number)")
        }
        
        return Layout(id: id,
                     number: Int(self.number),
                     gridText: self.gridText,
                     letterMap: self.letterMap)
    }
    
    func populate(from level: Layout) {
        self.id = level.id
        self.number = Int64(level.number ?? 0)
//        self.packId = level.packId
        self.gridText = level.gridText
        self.letterMap = level.letterMapStr
//        self.attemptedLetters = level.attemptedLettersStr
//        self.numCorrectLetters = Int16(level.numCorrectLetters)
    }
    
    func toLevel() -> Layout {
        guard let id = self.id else {
            fatalError("Missing id for LevelMO number \(self.number)")
        }
        
        return Layout(id: id,
                     number: Int(self.number),
//                     packId: self.packId,
                     gridText: self.gridText,
                     letterMap: self.letterMap) //,
//                     attemptedLetters: self.attemptedLetters)
//                     numCorrectLetters: Int(self.numCorrectLetters))
    }
}
