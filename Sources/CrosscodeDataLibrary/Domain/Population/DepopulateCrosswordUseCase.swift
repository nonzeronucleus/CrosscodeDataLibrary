import Foundation
import Factory

public protocol DepopulateCrosswordUseCase {
    func execute(crosswordLayout: String)  -> (String, String)
}


public final class DepopulateCrosswordUseCaseImpl: DepopulateCrosswordUseCase {
    public func execute(crosswordLayout: String) -> (String, String) {
        var crossword = Crossword(initString: crosswordLayout)
        
        crossword.depopulate()
        
        return (crossword.layoutString(),"")
    }
    
}
