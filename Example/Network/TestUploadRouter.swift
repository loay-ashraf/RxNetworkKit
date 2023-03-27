//
//  TestUploadRouter.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

enum TestUploadRouter: NetworkUploadRouter {
    case basic(accountId: String)
    case formData(accountId: String)
    var scheme: HTTPScheme {
        .https
    }
    var domain: String {
        "api.upload.io"
    }
    var path: String {
        switch self {
        case .basic(let accountId):
            return "v2/accounts/\(accountId)/uploads/binary"
        case .formData(let accountId):
            return "v2/accounts/\(accountId)/uploads/form_data"
        }
    }
    var headers: [String: String] {
        [:]
    }
    var parameters: [String: String]? {
        nil
    }
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
}
