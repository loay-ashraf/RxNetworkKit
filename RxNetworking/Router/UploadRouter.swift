//
//  UploadRouter.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

protocol UploadRouter: Router { }

extension UploadRouter {
    /// By Default: HTTP method is `POST` for upload requests.
    var method: HTTPMethod {
        .post
    }
    /// By Default: HTTP body is `nil` for upload requests (will be adapted by network manager).
    var body: [String : Any]? {
        nil
    }
}
