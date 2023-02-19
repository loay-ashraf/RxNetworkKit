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
    func request<T: Decodable, AE: NetworkAPIError>(_ router: Router, _ apiErrorType: AE.Type) -> Single<T> {
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

struct EmptyNetworkAPIError: NetworkAPIError {
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
        "www.catfact.ninja"
    }
    var path: String {
        "fact"
    }
    var method: String {
        "GET"
    }
    func asURLRequest() -> URLRequest {
        let urlString = scheme + "://" + host + "/" + path
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
}
