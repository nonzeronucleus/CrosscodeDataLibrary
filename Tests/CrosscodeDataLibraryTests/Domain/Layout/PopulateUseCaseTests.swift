import Testing
@testable import CrosscodeDataLibrary

class CrosscodeDataLibraryTests {
    let wordContainer = WordListContainer()
    @Test("Check that generation createss valid words"/*, .tags(.active)*/)
    func testPopulate() async throws {
        let alphabet: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        let currentTask: PopulationTask? = nil
        let crosswordLayout: String =  "   ..       ...|..     .. . ...|   . . .. .    |. .. . ........|.       .......|.. .... .......|.   ... ...   .|. .   . .   . .|.   ... ...   .|....... .... ..|.......       .|........ . .. .|    . .. . .   |... . ..     ..|...       ..   |"
        
//        let crossword = Crossword(initString:)
        
//        for _ in 0..<100 {
        for _ in 0..<100 {
            let populateUseCase = CrosswordPopulatorUseCase()
            
            
            let (output, _) = try await populateUseCase.execute(task: currentTask, crosswordLayout: crosswordLayout)
            
            let crossword: Crossword = Crossword(initString: output)
            let acrossClues: [Entry] = crossword.findEntries(direction: .across)
            let downClues: [Entry] = crossword.findEntries(direction: .down)
            
            areWordsGenuine(crossword: crossword, entries: acrossClues)
            areWordsGenuine(crossword: crossword, entries: downClues)
            
            #expect(crossword.getUsedLetters() == alphabet)
        }
    }
    
    func areWordsGenuine(crossword: Crossword, entries: [Entry]) {
        for entry in entries {
            let word = crossword.getWord(entry: entry)
            #expect (wordContainer.containsWord(word) == true)
        }
    }
}

extension Tag {
  @Tag static var active: Self
}
