// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Lingo",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "lingo", targets: ["Lingo"]),
        .plugin(name: "LingoPlugin", targets: ["LingoPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "1.0.0")),
        .package(url: "https://github.com/mobelux/swift-version-file-plugin.git", from: "0.2.0")
    ],
    targets: [
        .executableTarget(
            name: "Lingo",
            dependencies: [
                "LingoCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ]),
        .target(
            name: "LingoCore",
            dependencies: []),
        .plugin(
            name: "LingoPlugin",
            capability: .buildTool(),
            dependencies: ["Lingo"]),
        .testTarget(
            name: "CoreTests",
            dependencies: ["LingoCore"]),
        .testTarget(
            name: "LingoTests",
            dependencies: ["Lingo"])
    ]
)
