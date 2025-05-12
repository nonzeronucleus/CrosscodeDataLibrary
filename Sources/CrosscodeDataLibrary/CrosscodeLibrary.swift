import Swinject

public final class CrosscodeLibrary {
    private let di: DIAssembly
    
    /// Initialize with optional custom registrations
    public init(customRegistrations: ((Container) -> Void)? = nil) {
        di = DIAssembly()
        customRegistrations?(di.container)
    }
    
    /// Public API access
    public var api: CrosscodeAPI {
        di.resolve(CrosscodeAPI.self)
    }
    
    /// For testing - allows mock injections
    internal func override<T>(_ type: T.Type, with instance: T) {
        di.container.register(type) { _ in instance }
    }
}
