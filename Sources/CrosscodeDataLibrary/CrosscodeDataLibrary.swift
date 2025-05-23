import Factory
@_exported import CoreData

public struct CrosscodeDataLibrary {
    public static func setup() {
//        printLayout()
    }
    
//    @MainActor
    public static func printLayout() {
        Task {
            let fileRepository = FileLayoutRepository()
            do {
                _ = try await fileRepository.fetchAllLayouts()
            } catch {
                print("Error: \(error)")
            }
        }
    }
}


func printAllResourcesRecursively() {
    guard let bundleURL = Bundle.main.resourceURL else { return }
    
    let enumerator = FileManager.default.enumerator(
        at: bundleURL,
        includingPropertiesForKeys: [.nameKey, .pathKey],
        options: [.skipsHiddenFiles]
    )
    
    while let fileURL = enumerator?.nextObject() as? URL {
        if (fileURL.lastPathComponent == "Layouts.json") {
            print("Resource: \(fileURL.lastPathComponent)")
            //        print("Relative Path: \(fileURL.deletingPathExtension().lastPathComponent)")
            print("Full Path: \(fileURL.path)")
        }
    }
}


