// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "AppsView",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "AppsView",
            targets: ["AppsView"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftUI-Plus/ActivityView", .upToNextMajor(from: "1.2.0")),
    ],
    targets: [
        .target(
            name: "AppsView",
            dependencies: [
                .product(name: "ActivityView", package: "ActivityView"),
            ]
        ),
    ]
)
