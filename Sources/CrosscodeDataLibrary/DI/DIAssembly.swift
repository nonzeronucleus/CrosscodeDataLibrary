import Swinject

final class DIAssembly {
    public static let shared = DIAssembly() 
    let container: Container
    
    init(container: Container = Container()) {
        self.container = container
        assemble()
    }
    
    private func assemble() {
        DataDI.register(container: container)
        DomainDI.register(container: container)
        APIDI.register(container: container)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = container.resolve(type) else {
            fatalError("Failed to resolve \(type)")
        }
        return resolved
    }
}
