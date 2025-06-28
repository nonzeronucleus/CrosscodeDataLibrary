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
    
    var gameLevelRepository: Factory<GameLevelRepository> {
        Factory(self) {
            CoreDataGameLevelRepositoryImpl(context: self.managedObjectContext())
        }.singleton
    }
    
    internal var layoutExportFileRepository: Factory<FileRepository> {
        Factory(self) {
            DocumentFileRepository(fileName: "layout.json")
        }.singleton
    }
    
//    var importLayoutRepository: Factory<LayoutRepository> {
//        Factory(self) {
//            FileLayoutRepository()
//        }.singleton
//    }
}
