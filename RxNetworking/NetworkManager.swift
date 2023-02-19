//
//  NetworkManager.swift
//  RXNetworking
//
//  Created by Loay Ashraf on 16/02/2023.
//

import Foundation
import RxSwift
import RxSwiftExt
import RxCocoa
import Combine

struct NetworkEmptyModel: Decodable { }
typealias SingleEvent<Element, Error: Swift.Error> = Result<Element, Error>

class NetworkManager {
    private let session: URLSession
    init(session: URLSession) {
        self.session = session
    }
    func request<AE: NetworkAPIError>(_ router: Router, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Completable {
        let urlRequest = router.asURLRequest()
        let observable = session
            .rx
            .response(request: urlRequest)
            .decodable(AE.self)
        return observable
    }
    func request<T: Decodable, AE: NetworkAPIError>(_ router: Router, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Single<T> {
        let urlRequest = router.asURLRequest()
        let observable = session
            .rx
            .response(request: urlRequest)
            .decodable(T.self, errorType: AE.self)
        return observable
    }
}

protocol Router {
    func asURLRequest() -> URLRequest
}

protocol UploadRouter: Router {
    var headers: [String: Any] { get }
}

extension UploadRouter {
    var headers: [String: Any] {
        [:]
    }
}

struct DefaultNetworkAPIError: NetworkAPIError {
    let message: String
}

struct CatFact: Decodable {
    let fact: String
    let length: Int
}

enum CatFactRouter: Router {
    case fact
    var scheme: String {
        "https"
    }
    var host: String {
        "www.apimocha.com"
    }
    var path: String {
        "hi-world/test1"
    }
    var method: String {
        "GET"
    }
    var headers: [String: String] {
        ["Accept": "application/json",
         "Content-Type": "application/json"]
    }
    var url: URL? {
        let urlString = scheme + "://" + host + "/" + path
        return URL(string: urlString)
    }
    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url!)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        return request
    }
}
