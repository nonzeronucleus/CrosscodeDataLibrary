import Factory

public extension Container {
    // MARK: - Data Layer
    var managedObjectContext: Factory<NSManagedObjectContext> {
        Factory(self) { CoreDataStack.shared.viewContext }
    }
    
    var layoutRepository: Factory<LevelRepository> {
        Factory(self) {
            CoreDataLevelRepository<LayoutMO>(context: self.managedObjectContext())
        }.singleton
    }
    
    var playableLevelRepository: Factory<LevelRepository> {
        Factory(self) {
            CoreDataLevelRepository<PlayableLevelMO>(context: self.managedObjectContext())
        }.singleton
    }
    
    var importLayoutRepository: Factory<LayoutRepository> {
        Factory(self) {
            FileLayoutRepository()
        }.singleton
    }
}
