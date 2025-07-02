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
    
    var fetchGameLevelUseCase: Factory<FetchLevelUseCaseProtocol> {
        Factory(self) {
            FetchLevelUseCase(
                repository: self.gameLevelRepository()
            )
        }
    }
    
    var exportLayoutUseCase: Factory<ExportLayoutsUseCase> {
        Factory(self) {
            ExportLayoutsUseCaseImpl(
                layoutRepository: self.layoutRepository(),
                fileRepository: self.layoutExportFileRepository())
        }
    }

    var importLayoutsUseCase: Factory<ImportLayoutsUseCase> {
        Factory(self) {
            ImportLayoutsUseCaseImpl(
                fileRespositories: [self.layoutImportFileRepository(), self.layoutExportFileRepository()],
                layoutRepository: self.layoutRepository()
            )
        }
    }
    
    var exportGameLevelsUseCase: Factory<ExportGameLevelsUseCase> {
        Factory(self) {
            ExportGameLevelsUseCaseImpl(
                levelRepository: self.gameLevelRepository(),
                fileRepository: self.gameLevelExportFileRepository())
        }
    }

    var importGameLevelsUseCase: Factory<ImportLayoutsUseCase> {
        Factory(self) {
            ImportLayoutsUseCaseImpl(
                fileRespositories: [self.layoutImportFileRepository(), self.layoutExportFileRepository()],
                layoutRepository: self.layoutRepository()
            )
        }
    }
    
    internal var fetchAllPacksUseCase: Factory<FetchAllPacksUseCase> {
        Factory(self) {
            FetchAllPacksUseCaseImpl(
                repository: self.gameLevelRepository()
            )
        }
    }
    
    internal var addPackUseCase: Factory<AddPackUseCase> {
        Factory(self) {
            AddPackUseCaseImpl(
                repository: self.gameLevelRepository()
            )
        }
    }

}
