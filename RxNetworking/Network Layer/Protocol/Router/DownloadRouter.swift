//
//  DownloadRouter.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation

protocol DownloadRouter: Router { }

extension DownloadRouter {
    var method: HTTPMethod {
        .get
    }
    var body: [String : Any]? {
        nil
    }
}
