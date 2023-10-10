//
//  Reactive+ping.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/10/2023.
//

import Foundation
import RxSwift

extension Reactive where Base: URLSessionWebSocketTask {
    
    /// Sends a ping to the websocket server.
    ///
    /// - Returns: `Completable` observable encapsulating send ping operation.
    func ping() -> Completable {
        Completable.create { subscription in
            base.sendPing { error in
                guard let error = error else {
                    subscription(.completed)
                    return
                }
                subscription(.error(WebSocketError.ping(error: error)))
            }
            return Disposables.create()
        }
    }
    
}
