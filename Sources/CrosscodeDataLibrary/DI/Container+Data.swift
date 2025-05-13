import Factory

public extension Container {
    // MARK: - Data Layer
    var managedObjectContext: Factory<NSManagedObjectContext> {
        Factory(self) { CoreDataStack.shared.viewContext }
    }
    
    var levelRepository: Factory<LevelRepository> {
        Factory(self) {
            CoreDataLevelRepository(context: self.managedObjectContext())
        }.singleton
    }
}
