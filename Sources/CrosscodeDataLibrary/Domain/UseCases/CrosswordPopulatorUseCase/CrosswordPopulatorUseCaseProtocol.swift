protocol CrosswordPopulatorUseCaseProtocol {
    func execute(initCrossword: Crossword) async throws -> (Crossword, CharacterIntMap)
}
