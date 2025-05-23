import Factory
import CoreData

// Main container setup
public extension Container {
    // MARK: - Layouts
    var fetchAllLayoutsUseCase: Factory<FetchAllLayoutsUseCaseProtocol> {
        Factory(self) {
            FetchAllLayoutsUseCase(
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
    
    var deleteLayoutUseCase: Factory<DeleteLayoutUseCase> {
        Factory(self) {
            DeleteLayoutUseCaseImpl(
                repository: self.layoutRepository()
            )
        }
    }
    
    var saveLevelUseCase: Factory<SaveLevelUseCase> {
        Factory(self) { @MainActor in
            SaveLevelUseCaseImpl(
//                repository: self.levelRepository(),
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
    
    internal var addPlayableLevelUseCase: Factory<AddPlayableLevelUseCase> {
        Factory(self) {
            AddPlayableLevelUseCaseImpl()
        }
    }
    
    internal var importLayoutsUseCase: Factory<ImportLayoutsUseCase> {
        Factory(self) {
            ImportLayoutsUseCaseImpl(repository: self.layoutRepository(), fileRepository: self.importLayoutRepository())
        }
    }

}
