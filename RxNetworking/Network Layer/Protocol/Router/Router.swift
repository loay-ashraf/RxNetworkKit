//
//  Router.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 20/03/2023.
//

import Foundation

protocol Router {
    var scheme: HTTPScheme { get }
    var method: HTTPMethod { get }
    var domain: String { get }
    var path: String { get }
    var headers: [String: String] { get }
    var parameters: [String: String] { get }
    var body: [String: String] { get }
    var url: URL? { get }
    func asURLRequest() -> URLRequest
}
extension Router {
    func asURLRequest() -> URLRequest {
        // Add qurey parameters
        var urlComponents = URLComponents(url: url!, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0, value: $1) }
        let url = urlComponents?.url
        var request = URLRequest(url: url!)
        // Apply HTTP method
        request.httpMethod = method.rawValue
        // Apply HTTP body (if method is not GET)
        request.httpBody = method == .get ? nil : try? JSONSerialization.data(withJSONObject: body)
        // Apply HTTP headers
        request.allHTTPHeaderFields = headers
        return request
    }
}

protocol UploadRouter: Router {
    var headers: [String: Any] { get }
}

extension UploadRouter {
    var headers: [String: Any] {
        [:]
    }
}
