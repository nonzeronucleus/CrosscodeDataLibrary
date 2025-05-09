
// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "CrosscodeDataLibrary",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "CrosscodeDataLibrary",
            targets: ["CrosscodeDataLibrary"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CrosscodeDataLibrary",
            dependencies: [],
            resources: [
                .process("MyModel.xcdatamodeld")
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ]
        ),
        .testTarget(
            name: "CrosscodeDataLibraryTests",
            dependencies: ["CrosscodeDataLibrary"]),
    ]
)



// swift-tools-version:5.5
//import PackageDescription
//
//let package = Package(
//    name: "CrosscodeDataLibrary",
//    platforms: [
//        .macOS(.v10_15),
//        .iOS(.v13),
//        .tvOS(.v13),
//        .watchOS(.v6)
//    ],
//    products: [
//        .library(
//            name: "CrosscodeDataLibrary",
//            targets: ["CrosscodeDataLibrary"]),
//    ],
//    dependencies: [],
//    targets: [
//        .target(
//            name: "CrosscodeDataLibrary",
//            dependencies: []),
//        .testTarget(
//            name: "CrosscodeDataLibraryTests",
//            dependencies: ["CrosscodeDataLibrary"]),
//    ]
//)
//


