public struct Pos:Equatable, Hashable, Codable, Sendable {
    public let row:Int
    public let column:Int
    
    public init(row:Int, column:Int) {
        self.row = row
        self.column = column
    }
    
    static var nilPos:Pos { .init(row: -1, column: -1) }
    
    public static func / (lhs:Pos, rhs:Int) -> Pos {
        return Pos(row: lhs.row / rhs, column: lhs.column / rhs)
    }
}
