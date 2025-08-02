import Foundation

extension UUID {
    init(_ counter: Int) {
        let uuidString = String(format: "00000000-0000-0000-0000-%012d", counter)
        
        self = UUID(uuidString:uuidString)!
    }
}
