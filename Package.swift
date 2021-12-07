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
    dependencies: [
        .package(
            name: "ViewInspector",
            url: "https://github.com/nalexn/ViewInspector.git",
            .upToNextMajor(from: "0.9.0")
        )
    ],
    targets: [
        .target(
            name: "FilesUI",
            dependencies: [],
            linkerSettings: [.linkedFramework("SwiftUI")]
        ),
        .testTarget(
            name: "FilesUITests",
            dependencies: ["FilesUI", "ViewInspector"]),
    ]
)
