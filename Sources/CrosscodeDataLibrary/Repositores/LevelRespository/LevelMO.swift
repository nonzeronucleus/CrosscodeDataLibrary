import Foundation
import CoreData

public protocol LevelMO: NSManagedObject, NSFetchRequestResult {
    var number: Int64 { get }
    func populate(from level: any Level)
    
    func toLevel() -> any Level
}
