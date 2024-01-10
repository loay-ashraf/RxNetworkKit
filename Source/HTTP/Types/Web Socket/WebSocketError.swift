//
//  WebSocketError.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 09/10/2023.
//

import Foundation

/// An enumeration that contains cases where error is received from websocket.
public enum WebSocketError: Error {
    case receive(error: Error)
    case send(error: Error)
    case ping(error: Error)
}
