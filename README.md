# RxNetworking
![Swift](https://img.shields.io/badge/Swift-5.5-orange)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20macOS-yellowgreen)
![iOS](https://img.shields.io/badge/iOS-14.0%2B-black)
![macOS](https://img.shields.io/badge/macOS-11.0%2B-black)
![Cocoapods](https://img.shields.io/badge/Cocoapods-compatible-red)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)
[![Twitter](https://img.shields.io/badge/Twitter-%40lashraf96-blue)](https://twitter.com/lashraf96)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-loay--ashraf-blue)](https://linkedin.com/in/loay-ashraf)

RxNetworking is a lightweight FRP networking framework. 

Built on top of Apple's [URLSession](https://developer.apple.com/documentation/foundation/urlsession) and uses the well-known [RxSwift](https://github.com/ReactiveX/RxSwift) FRP library.

## Why RxNetworking?

RxNetworking fits nicely on your project if you use RxSwift and RxCocoa mainly in your project.

It makes use of RxSwift's traits at request level to acheive a high level of specialization for observed request sequence and expected output from it.

### Full of Goodies:

- includes download and upload capabillity with progress tracking all within the same observable sequence. cool, right?
- includes a request interceptor protocol that can be implemented for request adaptation and retry on failure.
- comes with a reachability class that you can observe from anywhere for reachability status.

## Requirements

| Platform | Minimum Swift Version | Installation | Status |
| --- | --- | --- | --- |
| iOS 14.0+ / macOS 11.0+ | 5.5 | [CocoaPods](#cocoapods), [Swift Package Manager](#swift-package-manager), [Manual](#manually) | Fully Tested |

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate RxNetworking into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'RxNetworking'
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding RxNetworking as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/loay-ashraf/RxNetworking.git", .upToNextMajor(from: "0.0.1"))
]
```

### Carthage

Support for Carthage is coming soon.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate RxNetworking into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add RxNetworking as a git [submodule](https://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/loay-ashraf/RxNetworking.git
  ```

- Open the new `RxNetworking` folder, and drag the `RxNetworking.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.
- Select the `RxNetworking.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see two different `RxNetworking.xcodeproj` folders each with two different versions of the `RxNetworking.framework` nested inside a `Products` folder.

    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `RxNetworking.framework`.
- Select the top `RxNetworking.framework` for iOS and the bottom one for macOS.

    > You can verify which one you selected by inspecting the build log for your project. The build target for `RxNetworking` will be listed as `RxNetworking iOS` or `RxNetworking macOS`.
- And that's it!

  > The `RxNetworking.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

## Credits

This project uses the 'Smart Retry' operator from this blog [Smart Retry](https://kean.blog/post/smart-retry) written by [Alex Grebenyuk](https://twitter.com/a_grebenyuk)
