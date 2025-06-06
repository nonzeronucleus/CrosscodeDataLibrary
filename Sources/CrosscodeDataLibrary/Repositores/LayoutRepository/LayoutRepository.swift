import Foundation

public protocol LayoutRepository : LevelRepository {

}

typealias CoreDataLayoutRepository = CoreDataLevelRepository<LayoutMO>


extension CoreDataLayoutRepository: LayoutRepository {
    
}


