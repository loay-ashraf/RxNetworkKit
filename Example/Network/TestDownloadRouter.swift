//
//  TestDownloadRouter.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation

enum TestDownloadRouter: DownloadRouter {
    case basic(accountId: String, filePath: String)
    var scheme: HTTPScheme {
        .https
    }
    var domain: String {
        "upcdn.io"
    }
    var path: String {
        switch self {
        case .basic(let accountId, let filePath):
            return "\(accountId)/raw/\(filePath)"
        }
    }
    var headers: [String: String] {
        switch self {
        case .basic:
            return ["Authorization": "Bearer public_FW25b9ZFF26sbDfyj9zR8EsHbzA4"]
        }
    }
    var parameters: [String: String]? {
        nil
    }
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
}
