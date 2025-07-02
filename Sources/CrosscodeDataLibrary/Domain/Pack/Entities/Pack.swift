//public protocol Level: Encodable, Equatable {
//    var id: UUID { get }
//
//    var number: Int? { get }
//    var crossword: Crossword { set get }
//    var letterMap: CharacterIntMap? {  set get }
//}


//
//public protocol Pack: Identifiable, Sendable, Encodable, Equatable where ID == UUID {
//    var id: UUID { get }
//    var number: Int { get }
//}

public struct Pack: Equatable, Identifiable {
    public var id: UUID
    public var number: Int
    
    public init(id: UUID = UUID(), number: Int) {
        self.id = id
        self.number = number
    }
}
