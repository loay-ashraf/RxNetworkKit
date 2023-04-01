//
//  DownloadRouter.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 01/04/2023.
//

import Foundation

enum DownloadRouter: NetworkDownloadRouter {
    case `default`(url: URL)
    var scheme: HTTPScheme {
        .https
    }
    var domain: String {
        ""
    }
    var path: String {
        ""
    }
    var headers: [String : String] {
        [:]
    }
    var parameters: [String : String]? {
        nil
    }
    var url: URL? {
        switch self {
        case .default(let url):
            return url
        }
    }
}
