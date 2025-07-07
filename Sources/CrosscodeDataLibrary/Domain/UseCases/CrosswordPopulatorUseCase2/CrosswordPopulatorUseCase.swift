extension Array where Element: Equatable {
    /// Removes first matching element
    mutating func remove(_ element: Element) {
        if let index = firstIndex(of: element) {
            remove(at: index)
        }
    }
    
    /// Removes all matching elements
    mutating func removeAll(_ element: Element) {
        removeAll { $0 == element }
    }
}



class CrosswordPopulatorUseCase: CrosswordPopulatorUseCaseProtocol {
    private var currentTask: PopulationTask?
    
    func execute(task: PopulationTask?, crosswordLayout: String) async throws -> (String, String) {
        // Cancel previous task if exists
        currentTask?.cancel()
        
        // Create new task
        currentTask = task
        let initCrossword = Crossword(initString: crosswordLayout)
        
        var crosswordPopulator = CrosswordPopulator(crossword: initCrossword)
        
        let (finalCrossword, charIntMap) = try await crosswordPopulator.populateCrossword(currentTask: task)
        
        return (finalCrossword.layoutString(), charIntMap.toJSON())
    }
    
    func cancel() {
        currentTask?.cancel()
    }
}
