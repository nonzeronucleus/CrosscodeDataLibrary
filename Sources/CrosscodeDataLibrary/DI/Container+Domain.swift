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
    
    var fetchAllPlayableLevelssUseCase: Factory<FetchAllLevelsUseCaseProtocol> {
        Factory(self) {
            FetchAllLevelsUseCase(
                repository: self.playableLevelRepository()
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
//        fatalError("\(#function) not implemented")
        Factory(self) {
            AddLayoutUseCase(
                repository: self.layoutRepository()
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
            SaveLevelLayoutUseCaseImpl(
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
    
    // Mark: - PlayableLevels
    
//    internal var addPlayableLevelUseCase: Factory<AddPlayableLevelUseCase> {
//        Factory(self) {
//            AddPlayableLevelUseCaseImpl()
//        }
//    }
    
    internal var importLayoutsUseCase: Factory<ImportLevelsUseCase> {
        Factory(self) {
            ImportLevelsUseCaseImpl(repository: self.layoutRepository(), fileRepository: self.importLayoutRepository())
        }
    }

}
