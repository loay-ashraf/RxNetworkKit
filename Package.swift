// swift-tools-version:5.3
//
//  Package.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/04/2023.
//

import PackageDescription

let package = Package(
    name: "RxNetworkKit",
    platforms: [
        .iOS(.v14), .macOS(.v11), .tvOS(.v14), .watchOS(.v7)
    ],
    products: [
        .library(name: "RxNetworkKit", targets: ["RxNetworkKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.6.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxSwiftExt", .upToNextMajor(from: "6.2.0"))
    ],
    targets: [
        .target(name: "RxNetworkKit", dependencies: ["RxSwift", "RxSwiftExt", .product(name: "RxCocoa", package: "RxSwift")], path: "Source"),
    ],
    swiftLanguageVersions: [.v5]
)
