import Foundation


@dynamicCallable
public protocol UUIDGenerator {
    func dynamicallyCall(withArguments args: [Any]) -> UUID
    func uuidGenerator() -> UUID

}

extension UUIDGenerator {
    // Default implementation that ignores arguments
    public func dynamicallyCall(withArguments args: [Any]) -> UUID {
        uuidGenerator()
    }
    
//    // Keep the original function for explicit calls
//    public func uuidGenerator() -> UUID {
//        dynamicallyCall(withArguments: [])
//    }
}


public struct RandomUUIDProvider: UUIDGenerator {
    // Implementation stays the same
    public func uuidGenerator() -> UUID {
        UUID()
    }
}

public final class IncrementingUUIDProvider: UUIDGenerator {
    private var counter = 0
    private let lock = NSLock()
    
    public init() {
        
    }
    
    public func uuidGenerator() -> UUID {
        lock.lock()
        defer { lock.unlock() }
        counter += 1
        let uuidString = String(format: "00000000-0000-0000-0000-%012d", counter)
        return UUID(uuidString: uuidString)!
    }
}

//
//protocol UUIDGenerator {
//    func uuidGenerator() -> UUID
//}
//
//
//struct RandomUUIDProvider: UUIDGenerator {
//    func uuidGenerator() -> UUID {
//        UUID()
//    }
//}
//
//final class IncrementingUUIDProvider: UUIDGenerator {
//    private var counter = 0
//    private let lock = NSLock()
//    
//    func uuidGenerator() -> UUID {
//        lock.lock()
//        defer { lock.unlock() }
//        counter += 1
//        let uuidString = String(format: "00000000-0000-0000-0000-%012d", counter)
//        return UUID(uuidString: uuidString)!
//    }
//}
//

