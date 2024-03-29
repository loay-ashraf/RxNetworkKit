//
//  RequestRouter.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/04/2023.
//

import Foundation
import RxNetworkKit

public enum RequestRouter: HTTPRequestRouter {
    case `default`
    public var scheme: HTTPScheme {
        .https
    }
    public var method: HTTPMethod {
        .get
    }
    public var domain: String {
        "api.github.com"
    }
    public var path: String {
        "users"
    }
    public var headers: [String : String] {
        ["Accept": "application/vnd.github+json"]
    }
    public var parameters: [String : String]? {
        nil
    }
    public var body: [String : Any]? {
        nil
    }
}
