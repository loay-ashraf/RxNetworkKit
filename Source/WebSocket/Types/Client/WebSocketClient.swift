//
//  WebSocketClient.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 17/05/2024.
//

import Foundation

/// Entry point for connecting to WebSocket servers.
public class WebSocketClient {
    
    /// Principal `Session` object that encapsulates `URLSession` instance.
    private let session: Session
    /// Principal `URLSession` object used to establish connections to WebSocket servers.
    private var urlSession: URLSession {
        session.urlSession
    }
    
    /// Creates a `WebSocketClient` instance.
    ///
    /// - Parameters:
    ///   - session: `Session` object that encapsulates `URLSession` instance.
    public init(session: Session) {
        // Initialize manager's properties.
        self.session = session
    }
    
    /// Creates a WebSocket object and establishes connection using provided url and protocols.
    ///
    /// - Parameters:
    ///   - url: `URL` of websocket server.
    ///   - protocols: `[String]` websocket connection protocols.
    ///   - closeHandler: `WebSocketCloseHandler` used to provide close coda and reason upon connection closure.
    ///
    /// - Returns: `WebSocket` object that represents the connection.
    public func webSocket<T: Decodable>(_ url: URL, _ protocols: [String], _ closeHandler: WebSocketCloseHandler) -> WebSocket<T> {
        let task = urlSession.webSocketTask(with: url, protocols: protocols)
        let webSocket = WebSocket<T>(task: task, closeHandler: closeHandler)
        return webSocket
    }
    
}
