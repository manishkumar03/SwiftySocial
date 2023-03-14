// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftySocial",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "SwiftySocial",
            targets: ["SwiftySocial"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftySocial",
            dependencies: []),
        .testTarget(
            name: "SwiftySocialTests",
            dependencies: ["SwiftySocial"]),
    ]
)
