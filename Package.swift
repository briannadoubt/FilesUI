// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "FilesUI",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .watchOS(.v8)],
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
