//
//  WebSocketCloseHandler.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/10/2023.
//

import Foundation

public class WebSocketCloseHandler {
    private let _code: (URLRequest?) -> WebSocketCloseCode
    private let _reason: (URLRequest?) -> Data?
    /// Creates `WebSocketCloseHandler` instance.
    ///
    /// - Parameters:
    ///   - code: a closure used to provide close code for a given `URLRequest` object.
    ///   - reason: a closure used to provide close reason for a given `URLRequest` object.
    public init(code: @escaping (URLRequest?) -> WebSocketCloseCode, reason: @escaping (URLRequest?) -> Data?) {
        self._code = code
        self._reason = reason
    }
    /// Provides close code for a given request.
    ///
    /// - Parameter request: `URLRequest?` object used to provide close code.
    ///
    /// - Returns: `WebSocketCloseCode` close code provided using given request.
    func code(for request: URLRequest?) -> WebSocketCloseCode {
        _code(request)
    }
    /// Provides close reason for a given request.
    ///
    /// - Parameter request: `URLRequest?` object used to provide close reason.
    ///
    /// - Returns: `Data?` close reason provided using given request.
    func reason(for request: URLRequest?) -> Data? {
        _reason(request)
    }
}
