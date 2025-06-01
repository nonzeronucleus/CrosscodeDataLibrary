import Foundation
import Factory

public protocol FetchLayoutUseCaseProtocol {
    func execute(id:UUID) async throws -> (any Level)?
}


public final class FetchLayoutUseCase: FetchLayoutUseCaseProtocol {
//    private let repository: LayoutRepository
    private let repository: LevelRepository

    // Dependency injected via Factory
    public init(repository: LevelRepository) {
//        public init(repository: LayoutRepository) {
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
//    var mockLevel: LevelLayout?
//    var errorToThrow: Error?
//    
//    func execute(id:UUID) async throws -> LevelLayout? {
//        if let error = errorToThrow { throw error }
//        guard let mockLevel = mockLevel else {
//            fatalError("\(#function) not implemented")
//        }
//        return mockLevel
//    }
//}
