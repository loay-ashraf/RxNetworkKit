//
//  HTTPURLResponse+StatusCode.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation

public extension HTTPURLResponse {
    var status: HTTPStatusCode? {
        return HTTPStatusCode(rawValue: statusCode)
    }
}
