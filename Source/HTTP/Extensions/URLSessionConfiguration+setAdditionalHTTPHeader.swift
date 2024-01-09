//
//  URLSessionConfiguration+setAdditionalHTTPHeader.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 21/08/2023.
//

import Foundation

extension URLSessionConfiguration {
    /// Sets additional HTTP header for a given key and value.
    ///
    /// - Parameters:
    ///   - key: `AnyHashable` key for the HTTP header.
    ///   - value: `Any` value for the HTTP header.
    func setAdditionalHTTPHeader(_ key: AnyHashable, value: Any) {
        var modifiedAdditionalHTTPHeaders = httpAdditionalHeaders ?? [:]
        modifiedAdditionalHTTPHeaders[key] = value
        httpAdditionalHeaders = modifiedAdditionalHTTPHeaders
    }
}
