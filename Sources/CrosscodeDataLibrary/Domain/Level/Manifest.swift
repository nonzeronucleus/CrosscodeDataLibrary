import Foundation


struct Manifest: Equatable {
    var fileDefinitions: [Int:PackDefinition] = [:]
    
    public init(manifestEntries: [Int: UUID]) {
        self.fileDefinitions = Dictionary(uniqueKeysWithValues:
            manifestEntries.map { (key, uuid) in
                (key, PackDefinition(id: uuid, packNumber: key))
            }
        )
    }
    
    public init(packs: [PackDefinition]) {
        self.fileDefinitions = Dictionary(uniqueKeysWithValues: packs.map { pack in (pack.packNumber!, pack) })
    }



    func getLevelFileDefinition(forNumber packNumber:Int) -> PackDefinition? {
        if let definition = fileDefinitions[packNumber] {
            return definition
        }
        return PackDefinition(packNumber: packNumber)
    }
    
    var maxLevelNumber:Int {
        return fileDefinitions.keys.max() ?? 0
    }
    
    func getNextPack(currentPack: PackDefinition) -> PackDefinition? {
        guard let currentPackNumber = currentPack.packNumber else { return nil }
        let nextPackNumber = currentPackNumber + 1
        return getLevelFileDefinition(forNumber: nextPackNumber)
    }
    
    func getPreviousPack(currentPack: PackDefinition) -> PackDefinition? {
        guard let currentPackNumber = currentPack.packNumber else { return nil }
        let nextPackNumber = currentPackNumber - 1
        return getLevelFileDefinition(forNumber: nextPackNumber)
    }
}

extension Manifest {
    static func == (lhs: Manifest, rhs: Manifest) -> Bool {
        return lhs.fileDefinitions == rhs.fileDefinitions
    }
}


//extension Manifest {
//  static let mock = Manifest (
////    packDefinitions: [
////        PackDefinition(packNumber: 1),
////        PackDefinition(packNumber: 2)
////    ]
//  )
//}
//            
