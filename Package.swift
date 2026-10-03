// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MultiSync",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "MultiSync", targets: ["MultiSyncApp"])
    ],
    targets: [
        .executableTarget(
            name: "MultiSyncApp",
            dependencies: ["MultiSyncCore"],
            path: "Sources/MultiSyncApp"
        ),
        .target(
            name: "MultiSyncCore",
            path: "Sources/MultiSyncCore"
        ),
        .testTarget(
            name: "MultiSyncCoreTests",
            dependencies: ["MultiSyncCore"],
            path: "Tests/MultiSyncCoreTests"
        )
    ]
)
