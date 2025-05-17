import Foundation


public protocol Grid2DItem: Hashable, Codable, Sendable {
    func toStorable() -> Character
    mutating func reset()
}

public struct  Grid2D<Element: Codable & Identifiable & Grid2DItem>: Hashable, Sendable {
    public static func == (lhs: Grid2D<Element>, rhs: Grid2D<Element>) -> Bool {
        lhs.id == rhs.id
    }
    
    private(set) var id: UUID
    private(set) var elements: [[Element]]

    public var rows: Int {
        get {
            return elements.count
        }
    }
    
    public var columns: Int {
        get {
            return elements.first?.count ?? 0
        }
    }

    init(rows: Int, columns: Int, elementGenerator: (Int, Int) -> Element) {
        self.id = UUID()
        self.elements = (0..<rows).map { row in
            (0..<columns).map { column in
                elementGenerator(row, column)
            }
        }
    }
    
    
    subscript(row: Int, column: Int) -> Element {
        get {
            precondition(isValidIndex(row: row, column: column), "Index out of bounds")
            return elements[row][column]
        }
        set {
            precondition(isValidIndex(row: row, column: column), "Index out of bounds")
            elements[row][column] = newValue
        }
    }

    func isValidIndex(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }

    mutating func updateAll(with transform: (Element) -> Element) {
        for row in 0..<rows {
            for column in 0..<columns {
                elements[row][column] = transform(elements[row][column])
            }
        }
    }

    func flatMapGrid<T>(_ transform: (Element) -> T) -> [[T]] {
        return elements.map { $0.map(transform) }
    }
    
    func listElements() -> [Element] {
        return elements.flatMap { $0 }
    }
    
    public func getRows() -> [[Element]] {
        return elements
    }
    
    func forEach(_ action: (Element, Int, Int) -> Void) {
        for row in 0..<rows {
            for column in 0..<columns {
                action(elements[row][column], row, column)
            }
        }
    }
    
    func findElement(byID id: Element.ID) -> Element? {
        for row in elements {
            if let element = row.first(where: { $0.id == id }) {
                return element
            }
        }
        return nil
    }
    
    
    public func locationOfElement(byID id: Element.ID) -> Pos? {
        for (rowIndex, row) in elements.enumerated() {
            if let columnIndex = row.firstIndex(where: { $0.id == id }) {
                return Pos(row: rowIndex, column: columnIndex)
            }
        }
        return nil
    }
    
    mutating func updateElement(byID id: Element.ID, with transform: (inout Element) -> Void) -> Bool {
        if let location = locationOfElement(byID: id) {
            transform(&elements[location.row][location.column])
            return true
        }
        return false
    }
    
    public mutating func updateElement(byPos location: Pos, with transform: (inout Element) -> Void) {
        transform(&elements[location.row][location.column])
    }
}


extension Grid2D: Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case rows
        case columns
        case elements
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(rows, forKey: .rows)
        try container.encode(columns, forKey: .columns)
        try container.encode(elements.flatMap { $0 }, forKey: .elements)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        let rows = try container.decode(Int.self, forKey: .rows)
        let columns = try container.decode(Int.self, forKey: .columns)
        let flatElements = try container.decode([Element].self, forKey: .elements)
        
        // Validate dimensions
        guard flatElements.count == rows * columns else {
            throw DecodingError.dataCorruptedError(
                forKey: .elements,
                in: container,
                debugDescription: "Expected \(rows * columns) elements but got \(flatElements.count)"
            )
        }
        
        // Rebuild 2D array
        elements = (0..<rows).map { row in
            let start = row * columns
            let end = start + columns
            return Array(flatElements[start..<end])
        }
    }
}

extension Grid2D {
    func toString() -> String {
        return elements.map { row in
            row.map { "\($0.toStorable())" }.joined(separator: "")
        }.joined(separator: "\n")
    }
}
