import Foundation
import Factory

public struct PackDefinition:Identifiable, Equatable, Hashable, Codable {
    public var id: UUID
    var packNumber: Int?
    
    init(id:UUID? = nil, packNumber:Int? = nil) {
        @Injected(\.uuid) var uuid
        if let id = id {
            self.id = id
        }
        else {
            self.id = uuid()
        }
        self.packNumber = packNumber
    }
}
