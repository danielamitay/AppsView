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
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),
    ],
    targets: [
        .target(
            name: "AppsView",
            dependencies: ["SwiftyJSON"]
        ),
    ]
)
