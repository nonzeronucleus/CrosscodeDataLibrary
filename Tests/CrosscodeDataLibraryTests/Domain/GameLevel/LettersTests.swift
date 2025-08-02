import Testing
import Foundation
@testable import CrosscodeDataLibrary

class LettersTests {
    @Test
    func testLetterCount() async throws {
        
        let gameLevel = GameLevel(
            id: UUID(0),
            number: 1,
            packId: UUID(0),
            gridText: "--|--|",
            letterMap: "QWERTYUIOPASDFGHJKLZXCVBNM",   // Array of letters to match number on grid, with 0 offset (e.g. first character in the array is the one numbered 1 on the grid)
            attemptedLetters: String(repeating: " ", count: 26)
            )
        
        #expect(gameLevel.letterMap.count == 26)
        
    }
}
