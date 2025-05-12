import Swinject

struct APIDI {
    static func register(container: Container) {
        container.register(CrosscodeAPI.self) { resolver in
            let repository = resolver.resolve(LevelRepository.self)!
            return CrosscodeAPI(repository: repository)
        }
    }
}
