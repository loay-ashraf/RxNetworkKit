//
//  HTTPMethod.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 20/03/2023.
//

/// An enumeration of the types of http methods.
public enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}
