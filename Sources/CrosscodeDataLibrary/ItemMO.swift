import CoreData
import Combine
import SwiftUI

@objc(ItemMO)
public class ItemMO: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
}

extension ItemMO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemMO> {
        return NSFetchRequest<ItemMO>(entityName: "Item")
    }
    
    @discardableResult
    public static func create(id: UUID = UUID(), name: String, in context: NSManagedObjectContext) -> ItemMO {
        let item = ItemMO(context: context)
        item.id = id
        item.name = name
        return item
    }
    
    func toItemData() -> ItemData {
        return ItemData(id: id, name: name)
    }
}


public struct ItemData: Identifiable {
    public var id: UUID
    public var name: String
}
