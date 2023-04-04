// swift-tools-version:5.3
//
//  Package.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 04/04/2023.
//

import PackageDescription

let package = Package(
    name: "RxNetworking",
    platforms: [
        .iOS(.v14), .macOS(.v11)
    ],
    products: [
        .library(name: "RxNetworking", targets: ["RxNetworking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.5.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxSwiftExt", .upToNextMajor(from: "6.1.0")),
    ],
    targets: [
        .target(name: "RxNetworking", dependencies: ["RxSwift", "RxSwiftExt",  .product(name: "RxCocoa", package: "RxSwift")], path: "RxNetworking"),
    ],
    swiftLanguageVersions: [.v5]
)
