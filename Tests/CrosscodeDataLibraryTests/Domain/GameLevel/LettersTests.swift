import Testing
import Foundation
@testable import CrosscodeDataLibrary

class LettersTests {
    @Test
    func testLetterCountWithNoAttempts() async throws {
        
        let gameLevel = GameLevel(
            id: UUID(0),
            number: 1,
            packId: UUID(0),
            gridText: "--|--|",
            letterMap: "QWERTYUIOPASDFGHJKLZXCVBNM",   // Array of letters to match number on grid, with 0 offset (e.g. first character in the array is the one numbered 1 on the grid)
            attemptedLetters: String(repeating: " ", count: 26)
        )
        
        #expect(gameLevel.numCorrectLetters == 0)
    }
    
    @Test
    func testLetterCountWithSomeCorrectAttempts() async throws {
        var gameLevel = GameLevel(
            id: UUID(0),
            number: 1,
            packId: UUID(0),
            gridText: "--|--|",
            letterMap: "QWERTYUIOPASDFGHJKLZXCVBNM",   // Array of letters to match number on grid, with 0 offset (e.g. first character in the array is the one numbered 1 on the grid)
            attemptedLetters: String(repeating: " ", count: 26)
        )
        
        gameLevel.attemptedLetters[2] = "E"
        gameLevel.attemptedLetters[3] = "R"

        #expect(gameLevel.numCorrectLetters == 2) // Two letters in the right place
    }

    @Test
    func testLetterCountWithSomeIncorrectAttempts() async throws {
        var gameLevel = GameLevel(
            id: UUID(0),
            number: 1,
            packId: UUID(0),
            gridText: "--|--|",
            letterMap: "QWERTYUIOPASDFGHJKLZXCVBNM",
            attemptedLetters: String(repeating: " ", count: 26)
        )
        
        gameLevel.attemptedLetters[12] = "E"
        gameLevel.attemptedLetters[13] = "R"

        #expect(gameLevel.numCorrectLetters == 0) // Two letters in the wrong place
    }
    
    @Test
    func testLetterCountWithSomeMixedAttempts() async throws {
        var gameLevel = GameLevel(
            id: UUID(0),
            number: 1,
            packId: UUID(0),
            gridText: "--|--|",
            letterMap: "QWERTYUIOPASDFGHJKLZXCVBNM",
            attemptedLetters: String(repeating: " ", count: 26)
        )
        
        gameLevel.attemptedLetters[2] = "E" // Correct
        gameLevel.attemptedLetters[3] = "R" // Correct
        gameLevel.attemptedLetters[15] = "Q" // Imcorrect
        gameLevel.attemptedLetters[25] = "M" // Correct

        #expect(gameLevel.numCorrectLetters == 3) // Three letters in the wrong place
    }
    
    @Test
    func testLetterCountWitAllCorrectAttempts() async throws {
        let gameLevel = GameLevel(
            id: UUID(0),
            number: 1,
            packId: UUID(0),
            gridText: "--|--|",
            letterMap: "QWERTYUIOPASDFGHJKLZXCVBNM",
            attemptedLetters: "QWERTYUIOPASDFGHJKLZXCVBNM"
        )
        
        #expect(gameLevel.numCorrectLetters == 26) // Three letters in the wrong place
    }
    
}
