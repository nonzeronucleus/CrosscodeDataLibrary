import Foundation
import Factory
import Combine

@MainActor  // Ensures CoreData operations run on the main thread
final class SaveLevelLayoutUseCaseImpl: SaveLevelUseCase {
//    private let repository: LayoutRepository
    private let repository: LevelRepository
    private var saveTask: Task<Void, Error>?
    private let debounceTime: UInt64 // in nanoseconds (e.g., 500_000_000 = 0.5s)

    init(
//        repository: LayoutRepository = Container.shared.layoutRepository(),
        repository: LevelRepository = Container.shared.layoutRepository(),
        debounceTime: UInt64 = 500_000_000 // Default: 0.5 seconds
    ) {
        self.repository = repository
        self.debounceTime = debounceTime
    }

    func execute(level: any Level) async throws {
        guard let layout = level as? LevelLayout else {
            fatalError("Invalid level type provided")
        }
        
        // Cancel the previous task if it exists
        saveTask?.cancel()

        // Start a new debounced task
        saveTask = Task { [weak self] in
            // Wait for debounce time (non-blocking for other operations)
            try await Task.sleep(nanoseconds: self?.debounceTime ?? 500_000_000)

            // Check if task was cancelled
            try Task.checkCancellation()

            // Proceed with save (runs on MainActor)
            try self?.repository.save(level: layout)
        }

        // Await the task's result (propagates errors if needed)
        try await saveTask?.value
    }
}

public protocol SaveLevelUseCase {
    func execute(level:any Level) async throws
}


//class SaveLevelUseCaseImpl: SaveLevelUseCase {
//    private let repository: LevelRepository
//
//    // Dependency injected via Factory
//    public init(repository: LevelRepository = Container.shared.levelRepository()) {
//        self.repository = repository
//    }
//
//    func execute(level:Level) async throws  {
//        try repository.saveLevel(level: level)
//    }
//}

