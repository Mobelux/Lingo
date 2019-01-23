// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Lingo",
    products: [
        .executable(name: "lingo", targets: ["lingo"])
    ],
    targets: [
        .target(
            name: "lingo",
            dependencies: ["LingoCore"]),
        .target(
            name: "LingoCore",
            dependencies: []),
        .testTarget(
            name: "LingoTests",
            dependencies: ["LingoCore"])
    ]
)
