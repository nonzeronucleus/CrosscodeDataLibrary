public final class CancellationToken: @unchecked Sendable {
    private let lock = NSLock()
    private var _isCancelled = false
    private var _onCancel: (@Sendable () -> Void)?
    
    public init() {}
    
    public func cancel() {
        lock.lock()
        defer { lock.unlock() }
        _isCancelled = true
        _onCancel?()
    }
    
    public func setOnCancel(_ handler: @escaping @Sendable () -> Void) {
        lock.lock()
        defer { lock.unlock() }
        _onCancel = handler
        if _isCancelled {
            handler()
        }
    }
    
    public var isCancelled: Bool {
        lock.lock()
        defer { lock.unlock() }
        return _isCancelled
    }
}
