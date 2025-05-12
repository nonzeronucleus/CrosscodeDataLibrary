import Swinject

struct DomainDI {
    static func register(container: Container) {
        container.register(FetchAllLayoutsUseCase.self) { resolver in
            let repo = resolver.resolve(LevelRepository.self)!
            return FetchAllLayoutsUseCaseImpl(repository: repo)
        }
    }
}
