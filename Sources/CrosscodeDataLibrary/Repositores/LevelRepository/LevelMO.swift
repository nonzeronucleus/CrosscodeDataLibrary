import CoreData
//
//@objc(LevelMO)
//public class LevelMO: NSManagedObject {
//    @NSManaged public var id: UUID?
//    @NSManaged public var number: Int64
//    @NSManaged public var packId: String?
//    @NSManaged public var gridText: String?
//    @NSManaged public var letterMap: String?
//    @NSManaged public var attemptedLetters: String?
//    @NSManaged public var numCorrectLetters: Int16
//}
//
//// MARK: - Generated accessors
//extension LevelMO {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<LevelMO> {
//        return NSFetchRequest<LevelMO>(entityName: "LevelMO")
//    }
//}



//import CoreData
//
//@objc(LevelMO)
//public class LevelMO: NSManagedObject {
//    @NSManaged public var id: UUID?
//    @NSManaged public var number: Int64
//    @NSManaged public var packId: String?
//    @NSManaged public var gridText: String?
//    @NSManaged public var letterMap: String?
//    @NSManaged public var attemptedLetters: String?
//    @NSManaged public var numCorrectLetters: Int16
//}
//
//extension LevelMO {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<LevelMO> {
//        return NSFetchRequest<LevelMO>(entityName: "LevelMO")
//    }
//}
//
//
//

//
extension LevelMO {
    func populate(from level: Level) {
        self.id = level.id
        self.number = Int64(level.number ?? 0)
        self.packId = level.packId
        self.gridText = level.gridText
        self.letterMap = level.letterMapStr
        self.attemptedLetters = level.attemptedLettersStr
        self.numCorrectLetters = Int16(level.numCorrectLetters)
    }
    
    func toLevel() -> Level {
        guard let id = self.id else {
            fatalError("Missing id for LevelMO number \(self.number)")
        }
        
        return Level(id: id,
                     number: Int(self.number),
                     packId: self.packId,
                     gridText: self.gridText,
                     letterMap: self.letterMap,
                     attemptedLetters: self.attemptedLetters,
                     numCorrectLetters: Int(self.numCorrectLetters))
    }
}
