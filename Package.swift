// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "FilesUI",
    platforms: [.iOS(.v14), .macOS(.v10_15), .tvOS(.v14), .watchOS(.v7)],
    products: [
        .library(
            name: "FilesUI",
            targets: ["FilesUI"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FilesUI",
            dependencies: [],
            linkerSettings: [.linkedFramework("SwiftUI")]
        ),
        .testTarget(
            name: "FilesUITests",
            dependencies: ["FilesUI"]),
    ]
)
