# Making Multipart Form Upload Requests

Make multipart form upload requests with **RxNetworkKit**

## Overview

In this article, we will walk you through on how to add a ``HTTPUploadRequestRouter`` and use it with ``HTTPClient`` to make multipart form upload requests.

### Adding an upload request router

In this section, you will be adding a ``HTTPUploadRequestRouter``.

- First, add a new Swift file to your project and name it *UploadRequestRouter.swift*.

- Second, add an import statement for **RxNetworkKit** to the top of the newly created file.

- Finally, add a new enumeration with the name `UploadRequestRouter` that conforms to the ``HTTPUploadRequestRouter`` protocol as done below:

```swift 
import Foundation
import RxNetworkKit

enum UploadRequestRouter: HTTPUploadRequestRouter {

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

- Note: Upload requests have `POST` http method set by default, so you don't have to specify it in the upload request router.

### Making a multipart form upload request

In this section, you will create a ``HTTPClient`` and use the ``HTTPUploadRequestRouter`` you created in the previous section with it to make a upload request.

- First, go to *ViewController.swift* file and create a ``HTTPClient`` using a ``Session`` in the `viewDidLoad` method

- Second, Create an `UploadRequestRouter`, a one ore more file `Data`, a one or more ``HTTPUploadRequestFile`` and a ``HTTPUploadRequestFormData``.

- Call the `HTTPClient.upload` method and pass the `UploadRequestRouter` and the ``HTTPUploadRequestFormData`` as arguments.

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
        let restClient = RESTClient(session: session, requestInterceptor: requestInterceptor)
        let httpClient = HTTPClient(session: session, requestInterceptor: requestInterceptor)
        // Replace with your upload url
        let uploadRequestRouter = UploadRequestRouter.default(url: URL(string: "https://example.com/upload/multi")!)
        let file1Data = "Example file 1".data(using: .utf8)!
        let file2Data = "Example file 2".data(using: .utf8)!
        let file1 = HTTPUploadRequestFile(forKey: "file1", withName: "example1.txt", withData: file1Data)!
        let file2 = HTTPUploadRequestFile(forKey: "file2", withName: "example2.txt", withData: file1Data)!
        let formData = HTTPUploadRequestFormData(parameters: [:], files: [file1, file2])
        httpClient.upload(uploadRequestRouter, formData)
            .subscribe(onNext: { (event: HTTPUploadRequestEvent<Model>) in
                switch event {
                case .progress(let progress):
                    // print upload progress
                    print("Uploading: \(progress.fractionCompleted)%")
                case .completed(let model):
                    // dump the received response body
                    dump(model)
                }
            }, onError: { error in
                // print the error description (if any)
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        }

}
```

- That's it, you made a multipart form upload request.

- Tip: If you need to upload a file from the disk, you can provide the file url through the `withURL` parameter to the ``HTTPUploadRequestFile`` initializer.

- Note: If you choose to upload a file from the disk, you don't have to specify the file name as it will be extracted from the provided file url.

- Note: You can specify additional text fields for the multipart from data through the `parameters` parameter.

- Warning: If you intend to make updates to the UI, you must use the `observe(on: MainScheduler.instance)` operator to avoid updating the UI on a background thread (which may lead to an unexpected behavior or a crash).

## Conclusion

Now, you can use **RxNetworkKit** to make multipart form upload requests.
