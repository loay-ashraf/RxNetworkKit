//
//  Reactive+receive.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/10/2023.
//

import Foundation
import RxSwift

extension Reactive where Base: URLSessionWebSocketTask {
    /// Starts receiving messages sent from websocket server.
    ///
    /// - Parameter closeHandler: `WebSocketCloseHandler` used to provide close coda and reason upon connection closure.
    ///
    /// - Returns: `Observable` object encapsulating received messages.
    func receive(closeHandler: WebSocketCloseHandler) -> Observable<WebSocketMessage> {
        func receive(subscription: AnyObserver<WebSocketMessage>) {
            base.receive { result in
                guard base.closeCode == .invalid else { return }
                switch result {
                case .success(let message):
                    subscription.onNext(message)
                    receive(subscription: subscription)
                case .failure(let error):
                    subscription.onError(error)
                }
            }
        }
        return Observable<WebSocketMessage>.create { subscription in
            receive(subscription: subscription)
            return Disposables.create {
                let request = base.currentRequest
                base.cancel(with: closeHandler.code(for: request), reason: closeHandler.reason(for: request))
            }
        }
        .share()
    }
}
