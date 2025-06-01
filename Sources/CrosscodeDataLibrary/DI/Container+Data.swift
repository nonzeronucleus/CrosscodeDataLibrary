import Factory

public extension Container {
    // MARK: - Data Layer
    var managedObjectContext: Factory<NSManagedObjectContext> {
        Factory(self) { CoreDataStack.shared.viewContext }
    }
    
//    var playableLevelRepository: Factory<PlayableLevelRepository> {
//        Factory(self) {
//            CoreDataPlayableLevelRepository(context: self.managedObjectContext())
//        }.singleton
//    }
    
//    var layoutRepository: Factory<LayoutRepository> {
//        Factory(self) {
//            CoreDataLayoutRepository(context: self.managedObjectContext())
//        }.singleton
//    }
//    
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
