//
//  HTTPDownloadRequestRouter.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation

/// Holds download request details.
public protocol HTTPDownloadRequestRouter: HTTPRequestRouter { }

public extension HTTPDownloadRequestRouter {
    
    /// By Default: HTTP method is GET for download requests.
    var method: HTTPMethod {
        .get
    }
    /// By Default: HTTP body is `nil` for download requests.
    var body: [String : Any]? {
        nil
    }
    
}
