//
//  RequestAdapter.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 27/03/2023.
//

import Foundation

protocol NetworkRequestAdapter {
    func adapt(_ request: URLRequest, for session: URLSession) -> URLRequest
}
