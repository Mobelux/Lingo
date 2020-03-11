// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Lingo",
    platforms: [
        .macOS(.v10_13)
    ],
    products: [
        .executable(name: "lingo", targets: ["Lingo"])
    ],
    targets: [
        .target(
            name: "Lingo",
            dependencies: ["LingoCore"]),
        .target(
            name: "LingoCore",
            dependencies: []),
        .testTarget(
            name: "LingoTests",
            dependencies: ["LingoCore"])
    ]
)
