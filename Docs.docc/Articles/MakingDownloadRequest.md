# Making Download Requests

Make download requests with **RxNetworkKit**

## Overview

In this article, we will walk you through on how to make download requests.

### Adding a download request router

In this section, you will be adding a ``HTTPDownloadRequestRouter``.

- First, add a new Swift file to your project and name it *DownloadRequestRouter.swift*.

- Second, add an import statement for **RxNetworkKit** to the top of the newly created file.

- Finally, add a new enumeration with the name `DownloadRequestRouter` that conforms to the ``HTTPDownloadRequestRouter`` protocol as done below:

```swift 
import Foundation
import RxNetworkKit

enum DownloadRequestRouter: HTTPDownloadRequestRouter {

    case `default`(url: URL)

    var scheme: HTTPScheme {
        .https
    }

    var domain: String {
        ""
    }

    var path: String {
        ""
    }

    var headers: [String : String] {
        [:]
    }

    var parameters: [String : String]? {
        nil
    }

    var url: URL? {
        switch self {
        case .default(let url):
            return url
        }
    }

}
```

- Note: Download requests have `GET` http method set by default, so you don't have to specify it in the download request router.

### Making a download request

In this section, you will create a ``HTTPClient`` and use the ``HTTPDownloadRequestRouter`` you created in the previous section with it to make a download request.

- First, go to *ViewController.swift* file and create a ``HTTPClient`` using a ``Session`` in the `viewDidLoad` method

- Second, Create a `DownloadRequestRouter`.

- Call the `HTTPClient.download` method and pass the `DownloadRequestRouter` as an argument.

- Subscribe to the output `Observable` as done below:

```swift
import UIKit
import RxSwift
import RxNetworkKit

class ViewController: UIViewController {

    let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let sessionConfiguration = SessionConfiguration.default
        let session = Session(configuration: sessionConfiguration)
        let requestInterceptor = RequestInterceptor()
        let httpClient = HTTPClient(session: session, requestInterceptor: requestInterceptor)
        // Replace with your download url
        let downloadRequestRouter = DownloadRequestRouter.default(url: URL(string: "https://example.com/image/2435454.png")!)
        httpClient.download(downloadRequestRouter)
            .subscribe(onNext: { event in
                switch event {
                case .progress(let progress):
                    // print download progress
                    print("Downloading: \(progress.fractionCompleted)%")
                case .completedWithData(data: let data):
                    // dump the received file data
                    dump(data)
                default: break
                }
            }, onError: { error in
                // print the error description (if any)
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }

}
```

- That's it, you made a download request.

- Tip: If you need to save the downloaded file to the disk, you can provide the save location url through the `fileURL` parameter.

- Note: If you choose to save the downloaded file to the disk, you will receive the `completed` download event instead of the `completedWithData` download event.

- Warning: If you intend to make updates to the UI, you must use the `observe(on: MainScheduler.instance)` operator to avoid updating the UI on a background thread (which may lead to unexpected behavior or crashes).

## Conclusion

Now, you can use **RxNetworkKit** to make download requests.
