import Factory
import CoreData

// Main container setup
public extension Container {
    // MARK: - Layouts
    var fetchAllLayoutsUseCase: Factory<FetchAllLevelsUseCaseProtocol> {
        Factory(self) {
            FetchAllLevelsUseCase(
                repository: self.layoutRepository()
            )
        }
    }
    
    var fetchAllGameLevelssUseCase: Factory<FetchAllLevelsUseCaseProtocol> {
        Factory(self) {
            FetchAllLevelsUseCase(
                repository: self.gameLevelRepository()
            )
        }
    }

    
    var fetchLayoutUseCase: Factory<FetchLevelUseCaseProtocol> {
        Factory(self) {
            FetchLevelUseCase(
                repository: self.layoutRepository()
            )
        }
    }

    
    var addLayoutUsecase: Factory<AddLayoutUseCaseProtocol> {
        Factory(self) {
            AddLayoutUseCase(
                repository: self.layoutRepository()
            )
        }
    }
    
    internal var addGameLevelUsecase: Factory<AddGameLevelUseCase> {
        Factory(self) {
            AddGameLevelUseCaseImpl(
                repository: self.gameLevelRepository()
            )
        }
    }

    
    var deleteLayoutUseCase: Factory<DeleteLevelUseCase> {
        Factory(self) {
            DeleteLevelUseCaseImpl(
                repository: self.layoutRepository()
            )
        }
    }
    
    var saveLevelUseCase: Factory<SaveLevelUseCase> {
        Factory(self) { @MainActor in
            SaveLayoutUseCaseImpl(
                repository: self.layoutRepository(),
                debounceTime: 500_000_000 // 0.5s debounce
            )
        }
    }
    
    // Mark: - Population
    
    internal var populateCrosswordUseCase: Factory<CrosswordPopulatorUseCaseProtocol> {
        Factory(self) {
            CrosswordPopulatorUseCase()
        }
    }
    
    internal var depopulateCrosswordUseCase: Factory<DepopulateCrosswordUseCase> {
        Factory(self) {
            DepopulateCrosswordUseCaseImpl()
        }
    }
    
    // Mark: - GameLevel
    
//    internal var addGameLevelUseCase: Factory<AddGameLevelUseCase> {
//        Factory(self) {
//            AddGameLevelUseCaseImpl()
//        }
//    }
    
    internal var importLayoutsUseCase: Factory<ImportLevelsUseCase> {
        Factory(self) {
            ImportLevelsUseCaseImpl(repository: self.layoutRepository(), fileRepository: self.importLayoutRepository())
        }
    }

}
