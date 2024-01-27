# Connecting To WebSocket Server

Connect to a web socket server with **RxNetworkKit**

## Overview

In this article we will walk you through on how to connect to a web socket server and how to send/receive messages and data.

### Creating a http client

In this section, you will create a ``HTTPClient`` using a ``Session``.

- First, go to *ViewController.swift* file.

- Second, create a ``HTTPClient`` using a ``Session`` in the `viewDidLoad` method as done below:

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
    }

}
```

- Now, you are ready to connect to a web socket server.

### Connecting to a websocket server

In this section, you will create a ``WebSocket`` and send/receive messages and data to/from the server.

- First, call the `HTTPClient.websocket` method and pass the server url, protocols and close handler as arguments.

- Second, Subscribe to the output `Observable`s and call `WebSocket.connect` method as done below:


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
        // Replace with your web socket server url
        let webSocket: WebSocket<Model> = httpClient.webSocket(URL(string: "wss://example")!,
                                                               ["ts1"],
                                                               .init(code: { _ in .normalClosure },
                                                                     reason: { _ in nil }))
        webSocket.text
            .subscribe(onNext: { text in
                // print incoming text message
                print(text)
            })
            .disposed(by: disposeBag)
        webSocket.data
            .subscribe(onNext: { model in
                // dump incoming data
                dump(model)
            })
            .disposed(by: disposeBag)
        webSocket.error
            .subscribe(onNext: { error in
                // print error description (if any)
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        webSocket.connect()
    }

}
```

- Optionally, you can send messages and data via the `WebSocket.send(_:)` method.

- That's it, you are connected to a web socket server and ready to send/receive messages and data.

- Tip: You can disconnect from the web socket server at any time by calling the `WebSocket.disconnect` method.

- Note: Connection to the web socket server is terminated when the ``WebSocket`` instance is deallocated.

- Warning: If you intend to make updates to the UI, you must use the `observe(on: MainScheduler.instance)` operator to avoid updating the UI on a background thread (which may lead to unexpected behavior or crashes).

## Conclusion

Now, you can use **RxNetworkKit** to connect to a web socket server.
