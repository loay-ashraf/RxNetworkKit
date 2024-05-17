//
//  HTTPRequestAdapter.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 27/03/2023.
//

import Foundation

/// Adapts outgoing requests.
public protocol HTTPRequestAdapter: AnyObject {
    
    /// Adapts a given request for a given session.
    ///
    /// - Parameters:
    ///   - request: current `URLRequest`
    ///   - session: current `URLSession`
    ///
    /// - Returns: `URLRequest` adapted request for a given session.
    func adapt(_ request: URLRequest, for session: URLSession) -> URLRequest
    
}
