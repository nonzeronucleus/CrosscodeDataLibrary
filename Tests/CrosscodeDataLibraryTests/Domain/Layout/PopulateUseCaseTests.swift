import Testing
@testable import CrosscodeDataLibrary


@MainActor
final class CrosscodeDataLibraryTests {
    let wordContainer = WordListContainer()
    
    // Test constants
    let alphabet: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    let crosswordLayout: String = "   ..       ...|..     .. . ...|   . . .. .    |. .. . ........|.       .......|.. .... .......|.   ... ...   .|. .   . .   . .|.   ... ...   .|....... .... ..|.......       .|........ . .. .|    . .. . .   |... . ..     ..|...       ..   |"
    
    @Test("Check that generation creates valid words", .tags(.inactive))
    func testPopulate() async throws {
        var wrongCount = 0
        
        for _ in 0..<100 {
            // Create new task with dummy operation (will be replaced in execute)
            let currentTask = PopulationTask { ("", "") }
            let populateUseCase = CrosswordPopulatorUseCase()
            
            do {
                let (output, _) = try await populateUseCase.execute(
                    task: currentTask,
                    crosswordLayout: crosswordLayout
                )
                
                var crossword = Crossword(initString: output)
                let allEntries = crossword.acrossEntries + crossword.downEntries
                
                // Validate words
                try validateWords(crossword: crossword, entries: allEntries)
                
                // Check all letters were used
                let usedLetters = crossword.getUsedLetters()
                #expect(
                    Set(usedLetters) == Set(alphabet),
                    "Missing letters: \(Set(alphabet).subtracting(usedLetters))"
                )
                
                // Check for duplicate words
                let words = allEntries.map { crossword.getWord(entry: $0) }
                #expect(words.count == Set(words).count,
                       "Duplicate words found: \(words.duplicates())")
                
                if words.count != Set(words).count {
                    wrongCount += 1
                }
                
            } catch {
                #expect(error.localizedDescription == "")
                wrongCount += 1
            }
        }
        
        #expect(wrongCount == 0, "Failed \(wrongCount) times out of 100")
    }
    
    private func validateWords(crossword: Crossword, entries: [Entry]) throws {
        for entry in entries {
            let word = crossword.getWord(entry: entry)
            #expect(wordContainer.containsWord(word),
                   "Invalid word found: \(word)")
        }
    }
}

// Helper extension
extension Sequence where Element: Hashable {
    func duplicates() -> [Element] {
        var seen = Set<Element>()
        return self.filter { !seen.insert($0).inserted }
    }
}

extension Tag {
    @Tag static var active: Self
    @Tag static var inactive: Self
}
