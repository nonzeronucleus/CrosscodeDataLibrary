// swift-tools-version:6.1

import PackageDescription

let package = Package(
    name: "CrosscodeDataLibrary",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "CrosscodeDataLibrary",
            targets: ["CrosscodeDataLibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", from: "2.4.2")
    ],
    targets: [
        .target(
            name: "CrosscodeDataLibrary",
            dependencies: [
                .product(name: "Factory", package: "Factory")
            ],
            resources: [
                .process("MyModel.xcdatamodeld"),  // CoreData model
                .process("Resources")  // Other resource files
            ],
            swiftSettings: [
                .define("DEBUG", .when(configuration: .debug))
            ]
        ),
        .testTarget(
            name: "CrosscodeDataLibraryTests",
            dependencies: ["CrosscodeDataLibrary"]
        )
    ]
)
