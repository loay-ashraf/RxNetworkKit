//
//  HTTPRequestRouter.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 20/03/2023.
//

import Foundation

/// Holds request details.
public protocol HTTPRequestRouter {
    
    /// http scheme of the request.
    var scheme: HTTPScheme { get }
    /// http method of the request.
    var method: HTTPMethod { get }
    /// url domain of the request, eg.: `github.com`.
    var domain: String { get }
    /// url path of the request, eg.:  `api/users`.
    var path: String { get }
    /// http headers of the request.
    var headers: [String: String] { get }
    /// url query parameters of the request.
    var parameters: [String: String]? { get }
    /// http body of the request.
    var body: [String: Any]? { get }
    /// full url of the request (including: domain, path and query parameters).
    var url: URL? { get }
    
    /// Creates a `URLRequest` object using router properties.
    ///
    /// - Returns: `URLRequest` created using router properties.
    func asURLRequest() -> URLRequest
    
}

public extension HTTPRequestRouter {
    
    /// full url of the request (including: domain and path).
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
    
    /// Creates `URLRequest` object using router properties.
    ///
    /// - Returns: `URLRequest` created using router properties.
    func asURLRequest() -> URLRequest {
        var url: URL? = self.url
        // Add qurey parameters
        if let parameters = parameters {
            var urlComponents = URLComponents(url: url!, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
            url = urlComponents?.url
        }
        var request = URLRequest(url: url!)
        // Apply HTTP method
        request.httpMethod = method.rawValue
        // Apply HTTP body (if method is not GET)
        if let body = body,
           method != .get {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        // Apply HTTP headers
        request.allHTTPHeaderFields = headers
        return request
    }
    
}
