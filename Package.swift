// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "AppsView",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "AppsView",
            targets: ["AppsView"]
        ),
    ],
    targets: [
        .target(name: "AppsView"),
    ]
)
