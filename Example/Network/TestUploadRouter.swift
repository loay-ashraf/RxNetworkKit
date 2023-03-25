//
//  TestUploadRouter.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

enum TestUploadRouter: UploadRouter {
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
        switch self {
        case .basic:
            return ["Authorization": "Bearer public_FW25b9ZFF26sbDfyj9zR8EsHbzA4"]
        case .formData:
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
