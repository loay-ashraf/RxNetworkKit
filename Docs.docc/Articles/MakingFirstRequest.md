# Making Your First Request

Make your first request with **RxNetworkKit**

## Overview

In this article, we will walk you through on how to add a ``HTTPRequestRouter`` and use it with ``RESTClient`` to make a request.

### Adding a request router

In this section, you will be adding a ``HTTPRequestRouter``.

- First, add a new Swift file to your project and name it *RequestRouter.swift*.

- Second, add an import statement for **RxNetworkKit** to the top of the newly created file.

- Finally, add a new enumeration with the name `RequestRouter` that conforms to the ``HTTPRequestRouter`` protocol as done below:

```swift 
import Foundation
import RxNetworkKit

enum RequestRouter: HTTPRequestRouter {

    case `default`

    var scheme: HTTPScheme {
        .https  // Replace with your endpoint http scheme
    }

    var method: HTTPMethod {
        .get    // Replace with your endpoint http method
    }

    var domain: String {
        "domain.com"    // Replace with your endpoint domain
    }

    var path: String {
        "path"  // Replace with your endpoint path
    }

    var headers: [String : String] {
        [:] // Replace with your endpoint http headers
    }

    var parameters: [String : String]? {
        nil // Replace with your endpoint query parameters
    }

    var body: [String : Any]? {
        nil // Replace with your endpoint http body
    }

}
```

- Tip: You can group related api endpoints in a single enumeration with dependencies (if any) as case associated values.

### Adding a model

In this section, you will be adding a `Decodable` model which will be a representation of the response body.

- First, add a new Swift file to your project and name it *Model.swift*.

- Second, add a structure with name `Model` that conforms to `Decodable` that matches the expected response body as done below:

```swift
import Foundation

struct Model: Decodable {

    let id: Int
    let avatarURL: URL
    let htmlURL: URL
    let login: String

    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case login
    }

}
```

- Now, you are ready to make a request using the ``HTTPRequestRouter`` and the `Decodable` model you created.

### Making a request

In this section, you will be using the ``HTTPRequestRouter`` you created in the previous section with ``RESTClient`` to make a request.

- First, go to *ViewController.swift* file and add an import statement for `RxSwift` to the top of the file.

- Second, create a dispose bag at the top of `ViewController` class.

- Create a `RequestRouter` in the `viewDidLoad` method.

- Call the `RESTClient.request` method and pass the `RequestRouter` as an argument.

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
        let requestRouter = RequestRouter.default
        restClient.request(requestRouter)
            .subscribe(onSuccess: { (model: Model) in
                // dump the received response body
                dump(model)
            }, onError: { error in 
                // print the error description (if any)
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }

}
```

- That's it, you made your first request.

- Tip: If you expect an empty response for the request you are making, you should subscribe to the `onCompleted` event instead of the `onSuccess` event.

- Note: It is best to apply an architectural pattern (like MVVM, MVP, VIPER, etc.) rather than making requests in the `ViewController` directly, but that is not done in the above example for the sake of simplicity.

- Warning: If you intend to make updates to the UI, you must use the `observe(on: MainScheduler.instance)` operator to avoid updating the UI on a background thread (which may lead to an unexpected behavior or a crash).

## Conclusion

Now, you are all set and can use **RxNetworkKit** to make requests.

You can check the other articles for more advanced usage.
