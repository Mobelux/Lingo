// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Lingo",
    targets: [
        .target(
            name: "Lingo",
            dependencies: ["LingoCore"]),
        .target(name: "LingoCore",
                dependencies: []),
        .testTarget(
            name: "LingoTests",
            dependencies: ["LingoCore"],
            sources: ["LingoTests.swift", "Expected.txt", "Localizeable.strings"]),
    ]
)
