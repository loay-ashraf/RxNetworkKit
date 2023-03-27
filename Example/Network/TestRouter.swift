//
//  TestRouter.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 20/03/2023.
//

import Foundation

enum TestRouter: NetworkRouter {
    case test1
    var scheme: HTTPScheme {
        .https
    }
    var method: HTTPMethod {
        .get
    }
    var domain: String {
        "www.apimocha.com"
    }
    var path: String {
        "hi-world/test1"
    }
    var headers: [String: String] {
        [:]
    }
    var parameters: [String: String]? {
        ["test": "hello"]
    }
    var body: [String: Any]? {
        ["test": "hello"]
    }
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
}
