# Connecting To WebSocket Server

Connect to a WebSocket server with **RxNetworkKit**

## Overview

In this article we will walk you through on how to connect to a WebSocket server and how to send/receive messages.

### Creating a http client

In this section, you will create a ``WebSocketClient`` using a ``Session``.

- First, go to *ViewController.swift* file.

- Second, create a ``WebSocketClient`` using a ``Session`` in the `viewDidLoad` method as done below:

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
        let webSocketClient = WebSocketClient(session: session)
    }

}
```

- Now, you are ready to connect to a WebSocket server.

### Connecting to a WebSocket server

In this section, you will create a ``WebSocket`` and send/receive messages to/from the server.

- First, call the `WebSocketClient.websocket` method and pass the server url, protocols and close handler as arguments.

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
        let webSocketClient = WebSocketClient(session: session)
        // Replace with your web socket server url
        let webSocket: WebSocket<Model> = webSocketClient.webSocket(URL(string: "wss://example")!,
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

- Optionally, you can send messages to the server via the `WebSocket.send(_:)` method.

- That's it, you are connected to a WebSocket server and ready to send/receive messages.

- Tip: You can disconnect from the WebSocket server at any time by calling the `WebSocket.disconnect` method.

- Note: Connection to the WebSocket server is terminated when the ``WebSocket`` instance is deallocated.

- Warning: If you intend to make updates to the UI, you must use the `observe(on: MainScheduler.instance)` operator to avoid updating the UI on a background thread (which may lead to unexpected behavior or crashes).

## Conclusion

Now, you can use **RxNetworkKit** to connect to a WebSocket server.
