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
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.1")),
    ],
    targets: [
        .target(
            name: "Lingo",
            dependencies: ["Core",
                           .product(name: "ArgumentParser", package: "swift-argument-parser")]),
        .target(
            name: "Core",
            dependencies: []),
        .testTarget(
            name: "LingoTests",
            dependencies: ["Core"])
    ]
)
