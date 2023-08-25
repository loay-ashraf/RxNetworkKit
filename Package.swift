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
        .iOS(.v14), .macOS(.v11)
    ],
    products: [
        .library(name: "RxNetworkKit", targets: ["RxNetworkKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.5.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxSwiftExt", .exact("6.0.1")),
    ],
    targets: [
        .target(name: "RxNetworkKit", dependencies: ["RxSwift", "RxSwiftExt",  .product(name: "RxCocoa", package: "RxSwift")], path: "Source"),
    ],
    swiftLanguageVersions: [.v5]
)
