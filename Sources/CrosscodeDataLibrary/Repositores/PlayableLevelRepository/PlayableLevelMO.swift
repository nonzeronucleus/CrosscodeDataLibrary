import CoreData

extension GameLevelMO: LevelMO {
    public func populate(from level: any Level) {
        guard let level = level as? GameLevel else {
            fatalError("Cannot populate \(Self.self) from \(type(of: level))")
        }
        self.id = level.id
        self.number = Int64(level.number ?? 0)
        self.packId = level.packId
        self.gridText = level.gridText
        self.letterMap = level.letterMapStr
        self.attemptedLetters = level.attemptedLettersStr
    }
    
    public func toLevel() -> any Level {
        guard let id = self.id else {
            fatalError("Missing id for LevelMO number \(self.number)")
        }
        
        if self.attemptedLetters == nil || self.attemptedLetters!.count < 26 {
            self.attemptedLetters = String(repeating: " ", count: 26)
        }
        
        return GameLevel(id: id,
                     number: Int(self.number),
                     packId: self.packId,
                     gridText: self.gridText,
                     letterMap: self.letterMap,
                     attemptedLetters: self.attemptedLetters) //,
    }
    
    func populate(from level: GameLevel) {
        self.id = level.id
        self.number = Int64(level.number ?? 0)
        self.packId = level.packId
        self.gridText = level.gridText
        self.letterMap = level.letterMapStr
        self.attemptedLetters = level.attemptedLettersStr
//        self.numCorrectLetters = Int16(level.numCorrectLetters)
    }
    
    func toLevel() -> GameLevel {
        guard let id = self.id else {
            fatalError("Missing id for LevelMO number \(self.number)")
        }
        
        if attemptedLetters == nil || attemptedLetters!.count < 26 {
            attemptedLetters = String(repeating: " ", count: 26)
        }
        
        return GameLevel(id: id,
                     number: Int(self.number),
                     packId: self.packId,
                     gridText: self.gridText,
                     letterMap: self.letterMap,
                     attemptedLetters: self.attemptedLetters) //,
//                     numCorrectLetters: Int(self.numCorrectLetters))
    }
}
