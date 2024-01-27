# Monitoring Network Reachability

Monitor network reachability status with **RxNetworkKit**

## Overview

In this article we will walk you through on how to monitor network reachability status and changes in it.

### Monitoring status

In this section, you will subscribe to the `status` output of the shared reachability class to monitor any changes in the network reachability status.

- First, go to `ViewController.swift` file.

- Second, in the `viewDidLoad` method subscribe to the `status` output of the `NetworkReachability.shared` object.

- Finally, call the `setInterfaceTypes` method and then call the `start` method of the `NetworkReachability.shared` object as done below:

```swift 
import UIKit
import RxSwift
import RxNetworkKit

class ViewController: UIViewController {

    let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkReachability.shared.status
            .subscribe(onNext: { status in
                // dump current reachability status
                dump(status)
            })
            .disposed(by: disposeBag)
        NetworkReachability.shared.setInterfaceTypes(NetworkInterfaceType.allCases)
        NetworkReachability.shared.start()
    }

}
```

- Now, you are ready to receive network reachability status updates and react accordingly.

- Tip: You can specify certain network interfaces to monitor the reachability status on by calling the `NetworkReachability.setInterfaceTypes(_:)` method

- Note: You must call the `NetworkReachability.start` method to receive network reachability status updates.

- Warning: If you intend to make updates to the UI, you must use the `observe(on: MainScheduler.instance)` operator to avoid updating the UI on a background thread (which may lead to unexpected behavior or crashes).

### Detecting if the network became reachable:

In this sesction, you will subscribe to the `didBecomeReachable` output of the shared reachability class to detect if the network became reachable.

- First, go to `ViewController.swift` file.

- Second, in the `viewDidLoad` method subscribe to the `didBecomeReachable` output of the `NetworkReachability.shared` object.

- Finally, call the `setInterfaceTypes` method and then call the `start` method of the `NetworkReachability.shared` object as done below:

```swift 
import UIKit
import RxSwift
import RxNetworkKit

class ViewController: UIViewController {

    let disposeBag: DisposeBag = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkReachability.shared.didBecomeReachable
            .subscribe(onNext: {
                // print that the network became reachable
                print("Network did become reachable!")
            })
            .disposed(by: disposeBag)
        NetworkReachability.shared.setInterfaceTypes(NetworkInterfaceType.allCases)
        NetworkReachability.shared.start()
    }

}
```

- Now, you are ready to detect if network became reachable and react accordingly.

- Tip: You can specify certain network interfaces to monitor the reachability status on by calling the `NetworkReachability.setInterfaceTypes(_:)` method

- Note: You must call the `NetworkReachability.start` method to receive network reachability status updates.

- Note: The `NetworkReachability.didBecomeReachable` output only sends events when the network becomes reachable after it has been unreachable.

- Warning: If you intend to make updates to the UI, you must use the `observe(on: MainScheduler.instance)` operator to avoid updating the UI on a background thread (which may lead to unexpected behavior or crashes).

## Conclusion

Now, you can use **RxNetworkKit** to monitor network reachability.
