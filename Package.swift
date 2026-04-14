// swift-tools-version: 5.10
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
        .executable(
            name: "ElementalDesignApp",
            targets: ["ElementalDesignApp"]
        ),
    ],
    targets: [
        .target(
            name: "ElementalDesign",
            path: "ElementalDesign",
            resources: [
                .process("Resources/Fonts")
            ]
        ),
        .executableTarget(
            name: "ElementalDesignApp",
            dependencies: ["ElementalDesign"],
            path: "ElementalDesignApp"
        ),
        .testTarget(
            name: "ElementalDesignTests",
            dependencies: ["ElementalDesign"],
            path: "ElementalDesignTests"
        ),
    ]
)
