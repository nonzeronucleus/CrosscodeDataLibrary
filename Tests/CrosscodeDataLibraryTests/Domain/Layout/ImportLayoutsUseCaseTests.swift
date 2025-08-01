import Testing
@testable import CrosscodeDataLibrary

class MockLayoutRepository: LayoutRepository {
    func create(level: any Level) throws {
        if let createError { throw createError }
        storedLayouts[level.id] = level as? Layout
    }
    
    func save(level: any Level) throws {
        fatalError("\(#function) not implemented")
    }
    
    
    func save(level: Layout) throws {
        fatalError("\(#function) not implemented")
    }
    
    func getHighestLevelNumber() async throws -> Int {
        fatalError("\(#function) not implemented")
    }
    
    func delete(id: UUID) async throws {
        fatalError("\(#function) not implemented")
    }
    
    var storedLayouts = [UUID: Layout]()
    var fetchError: Error?
    var createError: Error?
    
    func fetchAll() async throws -> [any Level] {

        if let fetchError { throw fetchError }
        return Array(storedLayouts.values)
    }
    
    func fetch(id: UUID) async throws -> (any Level)? {
        if let fetchError { throw fetchError }
        return storedLayouts[id]
    }
    
    func create(level: Layout) throws {
        if let createError { throw createError }
        storedLayouts[level.id] = level
    }
}

// MARK: - Test Data

extension Layout {
    static func mock(
        id: UUID = UUID(),
        number: Int? = 1,
        gridText: String? = "...|...|...|"
    ) -> Layout {
        Layout(
            id: id,
            number: number,
            gridText: gridText,
            letterMap: nil
        )
    }
}

class ImportLayoutsUseCaseTests {
    var sut: ImportLevelsUseCaseImpl!
    var mockMainRepository: MockLayoutRepository!
    var mockFileRepository: MockLayoutRepository!
    
    init() {
        mockMainRepository = MockLayoutRepository()
        mockFileRepository = MockLayoutRepository()
        
        // Initialize SUT with dependencies
        sut = ImportLevelsUseCaseImpl(
            repository: mockMainRepository,
            fileRepository: mockFileRepository
        )
    }
    
    @Test 
    func importNewLayouts_successfullyImports() async throws {
        // Given
        let layout1 = Layout.mock(id: UUID(), number: 1)
        let layout2 = Layout.mock(id: UUID(), number: 2)
        mockFileRepository.storedLayouts = [
            layout1.id: layout1,
            layout2.id: layout2
        ]
        
        // When
        try await sut.execute()
        
        // Then
        #expect(mockMainRepository.storedLayouts.count == 2)
        #expect(mockMainRepository.storedLayouts[layout1.id] != nil)
        #expect(mockMainRepository.storedLayouts[layout2.id] != nil)
    }
    
    @Test 
    func importSkipsExistingLayouts() async throws {
        // Initialize mock repositories
        // Given
        let existingLayout = Layout.mock(id: UUID(), number: 1)
        let newLayout = Layout.mock(id: UUID(), number: 2)
        
        mockMainRepository.storedLayouts = [existingLayout.id: existingLayout]
        
        
        mockFileRepository.storedLayouts = [
            existingLayout.id: existingLayout,
            newLayout.id: newLayout
        ]
        
        // When
        try await sut.execute()
        
        // Then
        #expect(mockMainRepository.storedLayouts.count == 2)
        #expect(mockMainRepository.storedLayouts[existingLayout.id]?.number == existingLayout.number)
    }
    
    @Test("Import fails when fetch fails")
    func importFailsWhenFetchFails() async {
        // Given
        mockFileRepository.fetchError = NSError(domain: "test", code: 1)
        
        // Then
        await #expect(throws: NSError.self) {
            try await self.sut.execute()
        }
    }
    
    @Test
    func importContinuesAfterSingleCreateFailure() async {
        // Arrange
        let goodLayout = Layout.mock(id: UUID(), number: 1)
        let badLayout = Layout.mock(id: UUID(), number: 2)
        
        mockFileRepository.storedLayouts = [
            goodLayout.id: goodLayout,
            badLayout.id: badLayout
        ]
        
        // Configure only the "bad" layout to fail
        mockMainRepository.createError = NSError(domain: "test", code: 2)
        
        // Act & Assert
        await #expect(throws: NSError.self) {
            try await self.sut.execute()
        }
        
        // Additional assertions about state
        #expect(mockMainRepository.storedLayouts.isEmpty)
    }
}
