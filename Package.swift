// swift-tools-version:5.5

// swiftlint:disable line_length

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
            url: "https://eu-de.git.cloud.ibm.com/blockchain-practice-dach/projects/ssi-bundeskanzleramt/id-wallet/ios-indy-sdk",
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
