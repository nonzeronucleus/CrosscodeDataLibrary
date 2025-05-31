//public protocol Level: Encodable, Equatable {
//    var id: UUID { get }
//
//    var number: Int? { get }
//    var crossword: Crossword { set get }
//    var letterMap: CharacterIntMap? {  set get }
//}



public protocol Level: Identifiable, Sendable, Encodable, Equatable where ID == UUID {
    static var api: LevelsAPI { get }
}
