// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "SoloCore",
    products: [
        .library(name: "SoloCore", targets: ["SoloCore"])
    ],
    targets: [
        .target(name: "SoloCore"),
        .testTarget(name: "SoloCoreTests", dependencies: ["SoloCore"]),
    ]
)
