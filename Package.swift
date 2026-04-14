// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ElementalDesign",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "ElementalDesign",
            targets: ["ElementalDesign"]
        ),
    ],
    targets: [
        .target(
            name: "ElementalDesign",
            path: "ElementalDesign"
        ),
        .testTarget(
            name: "ElementalDesignTests",
            dependencies: ["ElementalDesign"],
            path: "ElementalDesignTests"
        ),
    ]
)
