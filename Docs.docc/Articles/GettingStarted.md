# Getting Started

Add **RxNetworkKit** and the essential networking code to your project.

## Overview

You can add RxNetworkKit to your project as a Swift Package via SPM.

You also need to create ``Session`` and ``RESTClient`` objects so you can start making requests.

### Adding RxNetworkKit to your project

In this section, you will be adding RxNetworkKit to your project via Swift Package Manager.

- First, open the dependencies tab of your project.

- Tap the *+* button.

- In the search bar to the top right corner, paste this url:

[https://github.com/loay-ashraf/RxNetworkKit](https://github.com/loay-ashraf/RxNetworkKit)

- Tap the *Add Package* button to the bottom right corner.

![Add package window is visible and RxNetworkKit package is selected.](article-getting-started-#1.png)

- Second, tap the *Add Package* button and wait for Xcode to resolve package graph.

![Xcode is resolving the package graph.](article-getting-started-#2.png)

- Now, your all set and can now use **RxNetworkKit** in your project.

![Xcode has finished resolving the package graph and RxNetworkKit can be used in the project.](article-getting-started-#3.png)

### Adding required networking code

In this section, you will be creating ``Session`` and ``RESTClient`` objects.

- First, add a new Swift file to your project and name it *RequestInterceptor.swift*.

- Second, add an import statement for **RxNetworkKit** to the top of the newly created file.

- Add a new class with the name `RequestInterceptor` that conforms to the ``HTTPRequestInterceptor`` protocol as done below:

```swift
import Foundation
import RxNetworkKit

class RequestInterceptor: HTTPRequestInterceptor {
    
    func adapt(_ request: URLRequest, for session: URLSession) -> URLRequest {
        return request
    }
    
    func retryMaxAttempts(_ request: URLRequest, for session: URLSession) -> Int {
        return 5
    }
    
    func retryPolicy(_ request: URLRequest, for session: URLSession) -> HTTPRequestRetryPolicy {
        return .constant(time: 5.0)
    }
    
    func shouldRetry(_ request: URLRequest, for session: URLSession, dueTo error: HTTPError) -> Bool {
        return true
    }
    
}
```

- Finally, add an import statement for **RxNetworkKit** in *ViewController.swift* file and create ``SessionConfiguration``, ``Session`` and ``RESTClient`` objects in the `viewDidLoad` method as done below:

```swift
import UIKit
import RxNetworkKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let sessionConfiguration = SessionConfiguration.default
        let session = Session(configuration: sessionConfiguration)
        let requestInterceptor = RequestInterceptor()
        let restClient = RESTClient(session: session, requestInterceptor: requestInterceptor)
    }

}
```

- Alternatively, you can override the default ``SessionConfiguration`` by creating your own instance and providing different property values as done below:

```swift
import UIKit
import RxNetworkKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let sessionConfiguration = SessionConfiguration(urlSessionConfiguration: .default)
        sessionConfiguration.setUserAgentHeader = false
        sessionConfiguration.setUserAgentHeader = false
        let session = Session(configuration: sessionConfiguration)
        let requestInterceptor = RequestInterceptor()
        let restClient = RESTClient(session: session, requestInterceptor: requestInterceptor)
    }

}
```

## Conclusion

Now you are one step away from making a request using **RxNetworkKit**.

In the next article, you will learn how to create a ``HTTPRequestRouter`` and a `Decodable` model and use them with ``RESTClient`` to make a request.

You can read the next article here:
- <doc:MakingFirstRequest>
