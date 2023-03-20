//
//  TestRouter.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 20/03/2023.
//

import Foundation

enum TestRouter: Router {
    case test1
    var scheme: HTTPScheme {
        .https
    }
    var method: HTTPMethod {
        .post
    }
    var domain: String {
        "www.apimocha.com"
    }
    var path: String {
        "hi-world/test1"
    }
    var headers: [String: String] {
        ["Accept": "application/json",
         "Content-Type": "application/json"]
    }
    var parameters: [String: String] {
        ["test": "hello"]
    }
    var body: [String: String] {
        ["test": "hello"]
    }
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
}
