//
//  UploadRouter.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 24/03/2023.
//

import Foundation

protocol UploadRouter: Router { }

extension UploadRouter {
    var method: HTTPMethod {
        .post
    }
}
