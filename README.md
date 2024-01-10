# RxNetworkKit
![Swift](https://img.shields.io/badge/Swift-5.3-orange)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20macOS%20tvOS%20watchOS-yellowgreen)
![iOS](https://img.shields.io/badge/iOS-14.0%2B-black)
![macOS](https://img.shields.io/badge/macOS-11.0%2B-black)
![tvOS](https://img.shields.io/badge/tvOS-14.0%2B-black)
![watchOS](https://img.shields.io/badge/watchOS-7.0%2B-black)
![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen)
[![Twitter](https://img.shields.io/badge/Twitter-%40lashraf96-blue)](https://twitter.com/lashraf96)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-loay--ashraf-blue)](https://linkedin.com/in/loay-ashraf)

RxNetworkKit is a lightweight FRP networking framework. 

Built on top of Apple's [URLSession](https://developer.apple.com/documentation/foundation/urlsession) and uses the well-known [RxSwift](https://github.com/ReactiveX/RxSwift) FRP library.

## Why RxNetworkKit?

RxNetworkKit fits nicely on your project if you use RxSwift and RxCocoa mainly in your project.

It makes use of RxSwift's traits at request level to acheive a high level of specialization for observed request sequence and expected output from it.

### Full of Goodies:

- includes download and upload capabillity with progress tracking all within the same observable sequence. cool, right?
- includes a request interceptor protocol that can be implemented for request adaptation and retry on failure.
- comes with a reachability class that you can observe from anywhere for reachability status.

## Practical Examples

### Simple API Call:

```
// Create `Session` instance.
let session = Session(configuration: .default, eventMonitor: self)
// Create 'RESTClient' instance.
let restClient = RESTClient(session: session, requestInterceptor: self)
// Create `HTTPRequestRouter` instance.
let router = Router.default
// Make request observable sequence using request router.
let single: Single<Model> = restClient.request(router)
// Subscrible to sequence and observe events.
single
    .observe(on: MainScheduler.instance)
    .subscribe(onSuccess: {
        print("Task Response: \($0)")
        print("Task Completed!")
    }, onFailure: {
        print("Task Failure: \($0.localizedDescription)")
    }, onDisposed: {
        print("Subscription is disposed!")
    })
    // Dispose subscription by dispose bag.
    .disposed(by: disposeBag)
```

### Download Request:

```
// Create `Session` instance.
let session = Session(configuration: .default, eventMonitor: self)
// Create 'HTTPClient' instance.
let httpClient = HTTPClient(session: session, requestInterceptor: self)
// Create `HTTPDownloadRequestRouter` instance.
let router = DownloadRouter.default
// Make download request observable sequence using request router.
let downloadObservable: Observable<HTTPDownloadRequestEvent> = httpClient.download(router)
// Subscrible to sequence and observe events.
downloadObservable
    .observe(on: MainScheduler.instance)
    .subscribe(onNext: {
        switch $0 {
            case .progress(let progress):
                print("Download Task Progress: \(progress.fractionCompleted*100)%")
            case .completedWithData(let data):
                print("Download Task Completed with data: \(data).")
            default: break
         }
    }, onError: {
        print("Download Task Failure: \($0.localizedDescription)")
    }, onCompleted: {
        print("Download Task Completed!")
    })
    // Dispose subscription by dispose bag.
    .disposed(by: disposeBag)
```

### Upload Request:

```
// Create `Session` instance.
let session = Session(configuration: .default, eventMonitor: self)
// Create 'HTTPClient' instance.
let httpClient = HTTPClient(session: session, requestInterceptor: self)
// Create `HTTPUploadRequestRouter` instance.
let router = UploadRouter.default
// Make 'HTTPUploadRequestFile' instance.
let fileData = Data()
guard let file = UploadFile(forKey: UUID().uuidString, withName: "testFile.txt", withData: fileData) else { return }
// Make upload request observable sequence using request router and upload file object.
let uploadObservable: Observable<HTTPUploadRequestEvent<UploadModel>> = httpClient.upload(router, file)
// Subscrible to sequence and observe events.
uploadObservable
    .observe(on: MainScheduler.instance)
    .subscribe(onNext: {
        switch $0 {
            case .progress(let progress):
                print("Upload Task Progress: \(progress.fractionCompleted*100)%")
            case .completed(let model):
                print("Upload Task Completed with Response: \(model)")
        }
    }, onError: {
        print("Upload Task Failure: \($0.localizedDescription)")
    }, onCompleted: {
        print("Upload Task Completed!")
    })
    // Dispose subscription by dispose bag.
    .disposed(by: disposeBag)
```

## Requirements

| Platform | Minimum Swift Version | Installation | Status |
| --- | --- | --- | --- |
| iOS(iPadOS) 14.0+ / macOS 11.0+ / tvOS 14.0+ / watchOS 7.0+ | 5.3 | [Swift Package Manager](#swift-package-manager), [Manual](#manually) | Fully Tested |

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding RxNetworkKit as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/loay-ashraf/RxNetworkKit.git", .upToNextMajor(from: "1.0.0"))
]
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate RxNetworkKit into your project manually.

#### Embedded Framework

- Open up Terminal, `cd` into your top-level project directory, and run the following command "if" your project is not initialized as a git repository:

  ```bash
  $ git init
  ```

- Add RxNetworkKit as a git [submodule](https://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/loay-ashraf/RxNetworkKit.git
  ```

- Open the new `RxNetworkKit` folder, and drag the `RxNetworkKit.xcodeproj` into the Project Navigator of your application's Xcode project.

    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.
- Select the `RxNetworkKit.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.
- Next, select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
- In the tab bar at the top of that window, open the "General" panel.
- Click on the `+` button under the "Embedded Binaries" section.
- You will see one `RxNetworkKit.xcodeproj` folder with one `RxNetworkKit.framework` nested inside it.
- Select the `RxNetworkKit.framework`.
- And that's it!

  > The `RxNetworkKit.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.

## Credits

This project uses the `Smart Retry` operator from this blog [Smart Retry](https://kean.blog/post/smart-retry) written by [Alex Grebenyuk](https://twitter.com/a_grebenyuk)
