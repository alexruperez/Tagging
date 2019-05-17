// swift-tools-version:5.0

/**
 *  Tagging
 *  Copyright (c) alexruperez 2019
 *  Licensed under the MIT license (see LICENSE file)
 */

import PackageDescription

let package = Package(
    name: "Tagging",
    products: [
        .library(
            name: "Tagging",
            targets: ["Tagging"]
        )
    ],
    targets: [
        .target(
            name: "Tagging"),
        .testTarget(
            name: "TaggingTests",
            dependencies: ["Tagging"]
        )
    ]
)
