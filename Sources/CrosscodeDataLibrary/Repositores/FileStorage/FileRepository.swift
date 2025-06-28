import Foundation

protocol FileRepository {
    var url:URL {
        get
    }
    
    func exists() -> Bool
}
