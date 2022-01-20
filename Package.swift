// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Aries",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Aries",
            targets: ["Aries"]
        ),
    ],
    targets: [
        .target(
            name: "Aries",
            dependencies: ["Indy"]
        ),
        .binaryTarget(
            name: "Indy",
            path: "Frameworks/Indy.xcframework"
        ),
        .testTarget(
            name: "AriesTests",
            dependencies: ["Aries"],
            // We are not allowed to name a resource folder "Resources"?!
            resources: [.copy("Resource")]
        ),
    ]
)
