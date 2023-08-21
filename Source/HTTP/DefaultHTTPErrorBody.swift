//
//  DefaultHTTPErrorBody.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 21/08/2023.
//

import Foundation

struct DefaultHTTPErrorBody: HTTPErrorBody {
    let statusCode: Int?
    let message: String?
    let supportId: String?
}
