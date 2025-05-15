import Testing
@testable import CrosscodeDataLibrary

@Test func example() async throws {
    let wordContainer = WordListContainer()
    
    #expect(wordContainer.words.count > 0)
}
