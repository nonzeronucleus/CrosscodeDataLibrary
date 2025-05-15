import Factory
import CoreData

// Main container setup
public extension Container {
    // MARK: - Use Cases
    var fetchAllLayoutsUseCase: Factory<FetchAllLayoutsUseCaseProtocol> {
        Factory(self) {
            FetchAllLayoutsUseCase(
                repository: self.levelRepository()
            )
        }
    }
    
    var addLayoutUsecase: Factory<AddLayoutUseCaseProtocol> {
        Factory(self) {
            AddLayoutUseCase(
                repository: self.levelRepository()
            )
        }
    }
    
    var deleteLayoutUseCase: Factory<DeleteLayoutUseCase> {
        Factory(self) {
            DeleteLayoutUseCaseImpl(
                repository: self.levelRepository()
            )
        }
    }
    
    internal var populateCrosswordUseCase: Factory<CrosswordPopulatorUseCaseProtocol> {
        Factory(self) {
            CrosswordPopulatorUseCase()
        }
    }
}
