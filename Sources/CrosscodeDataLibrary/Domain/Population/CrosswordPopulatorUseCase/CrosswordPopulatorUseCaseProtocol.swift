protocol CrosswordPopulatorUseCaseProtocol {
//    func execute(initCrossword: Crossword) async throws -> (Crossword, CharacterIntMap)
    func execute(task: PopulationTask?, crosswordLayout: String) async throws -> (String, String)
}

