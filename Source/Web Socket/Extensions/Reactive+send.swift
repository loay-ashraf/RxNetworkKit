//
//  Reactive+send.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/10/2023.
//

import Foundation
import RxSwift

extension Reactive where Base: URLSessionWebSocketTask {
    /// Sends message to the websocket server.
    ///
    /// - Parameter message: `WebSocketMessage` to be sent to websocket server.
    ///
    /// - Returns: `Completable` observable encapsulating send message operation.
    func send(message: WebSocketMessage) -> Completable {
        Completable.create { subscription in
            base.send(message) { error in
                guard let error = error else {
                    subscription(.completed)
                    return
                }
                subscription(.error(error))
            }
            return Disposables.create()
        }
    }
}
