import Foundation


@dynamicCallable
public protocol UUIDGen {
    func dynamicallyCall(withArguments args: [Any]) -> UUID
    func uuidGenerator() -> UUID

}

extension UUIDGen {
    // Default implementation that ignores arguments
    public func dynamicallyCall(withArguments args: [Any]) -> UUID {
        uuidGenerator()
    }
    
//    // Keep the original function for explicit calls
//    public func uuidGenerator() -> UUID {
//        dynamicallyCall(withArguments: [])
//    }
}


public struct RandomUUIDProvider: UUIDGen {
    // Implementation stays the same
    public func uuidGenerator() -> UUID {
        UUID()
    }
}

//public final class IncrementingUUIDProvider: UUIDGen, Sendable {
//    private var counter = 0
//    private let lock = NSLock()
//    
//    public init() {
//        
//    }
//    
//    public func reset() {
//        counter = 0
//    }
//    
//    public func uuidGenerator() -> UUID {
//        lock.lock()
//        defer { lock.unlock() }
//        counter += 1
//        let uuidString = String(format: "00000000-0000-0000-0000-%012d", counter)
//        return UUID(uuidString: uuidString)!
//    }
//}

public final class IncrementingUUIDProvider: UUIDGen, @unchecked Sendable {
    private var counter: Int
    private let lock = NSLock()
    
    public init() {
        counter = 0
    }
    
    public func reset(_ val: Int = 0) {
        lock.lock()
        defer { lock.unlock() }
        counter = val
    }
    
    public func increase(_ val: Int = 0) {
        lock.lock()
        defer { lock.unlock() }
        counter += val
    }
    
    
    public func uuidGenerator() -> UUID {
        lock.lock()
        defer { lock.unlock() }
        counter += 1
        let uuidString = String(format: "00000000-0000-0000-0000-%012d", counter)
        return UUID(uuidString: uuidString)!
    }
}
