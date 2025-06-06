import Factory

public extension Container {
    // MARK: - Data Layer
    var managedObjectContext: Factory<NSManagedObjectContext> {
        Factory(self) { CoreDataStack.shared.viewContext }
    }
    
    var layoutRepository: Factory<LevelRepository> {
        Factory(self) {
            CoreDataLayoutRepository(context: self.managedObjectContext())
        }.singleton
    }
    
    var playableLevelRepository: Factory<PlayableLevelRepository> {
        Factory(self) {
            CoreDataPlayableLevelRepositoryImpl(context: self.managedObjectContext())
        }.singleton
    }
    
    var importLayoutRepository: Factory<LayoutRepository> {
        Factory(self) {
            FileLayoutRepository()
        }.singleton
    }
}
