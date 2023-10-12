//
//  DownloadRequestRouter.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 01/04/2023.
//

import Foundation

public enum DownloadRequestRouter: HTTPDownloadRequestRouter {
    case `default`(url: URL)
    public var scheme: HTTPScheme {
        .https
    }
    public var domain: String {
        ""
    }
    public var path: String {
        ""
    }
    public var headers: [String : String] {
        [:]
    }
    public var parameters: [String : String]? {
        nil
    }
    public var url: URL? {
        switch self {
        case .default(let url):
            return url
        }
    }
}
