import Foundation


protocol UUIDGenerator {
    func uuidGenerator() -> UUID
}


struct RandomUUIDProvider: UUIDGenerator {
    func uuidGenerator() -> UUID {
        UUID()
    }
}

final class IncrementingUUIDProvider: UUIDGenerator {
    private var counter = 0
    private let lock = NSLock()
    
    func uuidGenerator() -> UUID {
        lock.lock()
        defer { lock.unlock() }
        counter += 1
        let uuidString = String(format: "00000000-0000-0000-0000-%012d", counter)
        return UUID(uuidString: uuidString)!
    }
}


