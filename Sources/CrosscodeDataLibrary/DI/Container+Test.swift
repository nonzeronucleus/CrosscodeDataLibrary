import Factory

extension Container {
    func setupTestMocks() {
        let _ = Container.shared.uuid
            .register { IncrementingUUIDProvider() }
            .singleton
        
        let _ = Container.shared.levelRepository
            .register { MockLevelRepository() }
            .singleton
    }
}
