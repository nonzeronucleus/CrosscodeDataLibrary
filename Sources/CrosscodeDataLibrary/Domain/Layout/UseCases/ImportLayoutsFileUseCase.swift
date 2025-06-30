import Foundation
import Factory

public protocol ImportLayoutsUseCase {
    func execute() async throws -> [Layout]
}

struct ImportLayoutsUseCaseImpl: ImportLayoutsUseCase {
    let fileRespositories: [FileRepository]
    let layoutRepository: LayoutRepository
    
    func execute() async throws -> [Layout] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        guard let fileRepository = fileRespositories.first(where: { $0.exists() }) else { return [] }
                
        let jsonData = try fileRepository.read() 
        let layouts = try decoder.decode([Layout].self, from: jsonData)
        
        for layout in layouts {
            if try await layoutRepository.fetch(id: layout.id) == nil {
                try layoutRepository.create(level: layout)
            }
        }
        
        return layouts
    }
}
