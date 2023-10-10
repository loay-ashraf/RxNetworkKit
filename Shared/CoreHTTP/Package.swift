// swift-tools-version:5.3
//
//  Package.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/04/2023.
//

import PackageDescription

let package = Package(
    name: "CoreHTTP",
    platforms: [
        .iOS(.v14), .macOS(.v11)
    ],
    products: [
        .library(name: "CoreHTTP", targets: ["CoreHTTP"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "CoreHTTP", dependencies: [], path: "Source"),
    ],
    swiftLanguageVersions: [.v5]
)
