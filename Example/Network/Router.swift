//
//  Router.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 01/04/2023.
//

import Foundation

enum Router: NetworkRouter {
    case `default`
    var scheme: HTTPScheme {
        .https
    }
    var method: HTTPMethod {
        .get
    }
    var domain: String {
        "api.github.com"
    }
    var path: String {
        "users"
    }
    var headers: [String : String] {
        ["Accept": "application/vnd.github+json"]
    }
    var parameters: [String : String]? {
        nil
    }
    var body: [String : Any]? {
        nil
    }
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
}
