import Foundation
import Factory

public protocol FetchLevelUseCaseProtocol {
    func execute(id:UUID) async throws -> (any Level)?
}


public final class FetchLevelUseCase: FetchLevelUseCaseProtocol {
    private let repository: LevelRepository

    // Dependency injected via Factory
    public init(repository: LevelRepository) {
        self.repository = repository
    }
    
    public func execute(id:UUID) async throws -> (any Level)? {
        guard let layout = try await repository.fetch(id: id) else {
            return nil
        }
        
        return layout
    }
}

//
//final class MockFetchLayoutUseCase: FetchLayoutUseCaseProtocol {
//    var mockLevel: Layout?
//    var errorToThrow: Error?
//
//    func execute(id:UUID) async throws -> Layout? {
//        if let error = errorToThrow { throw error }
//        guard let mockLevel = mockLevel else {
//            fatalError("\(#function) not implemented")
//        }
//        return mockLevel
//    }
//}
