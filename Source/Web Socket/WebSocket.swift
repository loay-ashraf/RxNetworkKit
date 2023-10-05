//
//  WebSocket.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/10/2023.
//

import Foundation
import RxSwift
import RxRelay

/// Encapsulates a connection to websocket server.
public class WebSocket<T: Decodable> {
    
    /// a `PublishRelay` object for text messages received from websocket server.
    public let text: PublishRelay<String> = .init()
    /// a generic `PublishRelay` object for data messages received from websocket server.
    public let data: PublishRelay<T> = .init()
    /// a `PublishRelay` object for errors encountered while receiving/sending from/to websocket server.
    public let error: PublishRelay<Error> = .init()
    private let task: URLSessionWebSocketTask
    private let closeHandler: WebSocketCloseHandler
    private let receiveObservable: Observable<WebSocketMessage>
    private let disposeBag: DisposeBag = .init()
    
    /// Creates a `WebSocket` instance with generic tyoe `T`.
    ///
    /// - Parameters:
    ///   - task: `URLSessionWebSocketTask` that represents the connection to websocket server.
    ///   - closeHandler: `WebSocketCloseHandler` used to provide close coda and reason upon connection closure.
    init(task: URLSessionWebSocketTask, closeHandler: WebSocketCloseHandler) {
        self.task = task
        self.closeHandler = closeHandler
        self.receiveObservable = task.rx.receive(closeHandler: closeHandler)
        setupBindings()
    }
    
    /// Resumes current task to establish the connection.
    public func connect() {
        task.resume()
    }
    
    /// Cancels the request associated with current task to close the connection.
    public func disconnect() {
        let request = task.currentRequest
        task.cancel(with: closeHandler.code(for: request), reason: closeHandler.reason(for: request))
    }
    
    /// Sends message to the websocket server.
    ///
    /// - Parameter message: `WebSocketMessage` to be sent to websocket server.
    ///
    /// - Returns: `Completable` observable encapsulating send message operation.
    public func send(_ message: WebSocketMessage) -> Completable {
        task.rx.send(message: message)
    }
    
    /// Sends a ping to the websocket server.
    ///
    /// - Returns: `Completable` observable encapsulating send ping operation.
    public func ping() -> Completable {
        task.rx.ping()
    }
    
    /// Sets up internal observable bindings.
    private func setupBindings() {
        receiveObservable
            .materialize()
            .compactMap({
                guard case .next(let element) = $0, case .string(let text) = element else { return nil }
                return text
            })
            .bind(to: text)
            .disposed(by: disposeBag)
        receiveObservable
            .materialize()
            .compactMap({
                guard case .next(let element) = $0, case .data(let data) = element else { return nil }
                return data
            })
            .flatMap({ (data: Data) in
                if T.self == Data.self {
                    return Observable.just(data as! T)
                } else {
                    return Observable.just(data)
                        .decode(type: T.self, decoder: JSONDecoder())
                }
            })
            .bind(to: data)
            .disposed(by: disposeBag)
        receiveObservable
            .materialize()
            .compactMap({
                guard case .error(let error) = $0 else { return nil }
                return error
            })
            .bind(to: error)
            .disposed(by: disposeBag)
    }
    
}
