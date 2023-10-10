//
//  DefaultHTTPBodyError.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 21/08/2023.
//

import Foundation

/// Default type used for decoding http error bodies.
public struct DefaultHTTPBodyError: HTTPBodyError {
    
    /// response status code.
    let statusCode: Int?
    /// error message.
    let message: String?
    /// support identifier.
    let supportId: String?
    
}
