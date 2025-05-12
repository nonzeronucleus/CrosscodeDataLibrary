import Swinject

struct DataDI {
    static func register(container: Container) {
        // CoreData stack
        container.register(CoreDataStackProtocol.self) { _ in
            CoreDataStack.shared
        }
        
        // Repositories
        container.register(LevelRepository.self) { resolver in
            let coreDataStack = resolver.resolve(CoreDataStackProtocol.self)!
            return CoreDataLevelRepositoryImpl(context: coreDataStack.context)
        }.inObjectScope(.container)
        
        // Add other data components (Network, Database, etc)
    }
}


//import Swinject
//
//class DataDIContainer {
//    let container: Container
//    
//    init(_ container: Container) {
//        self.container = container
//        registerServices()
//    }
//    
//    private func registerServices() {
//        container.register(LevelRepository.self) { _ in
//            CoreDataLevelRepositoryImpl(context: CoreDataStack.shared.context)
//        }.inObjectScope(.container)
//    }
//}
//
//import Swinject
//
//public class DIContainer {
//    public static let shared = DIContainer()
//    private let container = Container()
//    
//    private init() {
//        setupDependencies()
//    }
//    
//    private func setupDependencies() {
//        container.register(CoreDataStackProtocol.self) { _ in
//            CoreDataStack.shared
//        }
//
//        container.register(LevelRepository.self) { resolver in
//            let coreDataStack = resolver.resolve(CoreDataStackProtocol.self)!
//            return CoreDataLevelRepositoryImpl(context: coreDataStack.context)
//        }
//        
//        // CoreData Stack registration (if you need to inject it)
//        container.register(NSManagedObjectContext.self) { _ in
//            CoreDataStack.shared.context
//        }
//        
//        // CrosscodeAPI registration
//        container.register(CrosscodeAPI.self) { resolver in
//            let repository = resolver.resolve(LevelRepository.self)!
//            return CrosscodeAPI(repository: repository)
//        }
//    }
//    
//    public func resolve<T>(_ type: T.Type) -> T {
//        guard let dependency = container.resolve(type) else {
//            fatalError("Failed to resolve \(type)")
//        }
//        return dependency
//    }
//}
