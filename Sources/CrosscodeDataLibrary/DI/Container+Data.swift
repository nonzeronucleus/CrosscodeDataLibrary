import Factory

public extension Container {
    // MARK: - Data Layer
    var managedObjectContext: Factory<NSManagedObjectContext> {
        Factory(self) { CoreDataStack.shared.viewContext }
    }
    
    var layoutRepository: Factory<LayoutRepository> {
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
            DocumentFileRepository(fileName: "layout")
        }.singleton
    }
    
    internal var layoutImportFileRepository: Factory<FileRepository> {
        Factory(self) {
            ResourceFileRepository(fileName: "layout")
        }.singleton
    }

    internal var gameLevelExportFileRepository: Factory<FileRepository> {
        Factory(self) {
            DocumentFileRepository(fileName: "level")
        }.singleton
    }
    
    internal var gameLevelImportFileRepository: Factory<FileRepository> {
        Factory(self) {
            ResourceFileRepository(fileName: "level")
        }.singleton
    }

//    var importLayoutRepository: Factory<LayoutRepository> {
//        Factory(self) {
//            FileLayoutRepository()
//        }.singleton
//    }
}
