// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Aries",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "Aries",
            targets: ["Aries"]
        )
    ],
	dependencies: [
		.package(
            name: "Indy",
            url: "git@github.com:My-DIGI-ID/id-wallet-2-ios-indy-sdk.git",
            branch: "development"
        )
	],
    targets: [
        .target(
            name: "Aries",
            dependencies: ["Indy"]
        ),
        .testTarget(
            name: "AriesTests",
            dependencies: ["Aries"],
            resources: [.copy("Resource")]
        )
    ]
)
