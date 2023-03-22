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
    func upload<T: Decodable, AE: NetworkAPIError>(_ router: Router, _ data: Data, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Observable<UploadEvent<T>> {
        let urlRequest = router.asURLRequest()
        let observable = session
            .rx
            .response(request: urlRequest, data: data, modelType: T.self, apiErrorType: AE.self)
        return observable
    }
    func upload<T: Decodable, AE: NetworkAPIError>(_ router: UploadRouter, _ file: URL, _ apiErrorType: AE.Type = DefaultNetworkAPIError.self) -> Observable<UploadEvent<T>> {
        let urlRequest = router.asURLRequest()
        let observable = session
            .rx
            .response(request: urlRequest, file: file, modelType: T.self, apiErrorType: AE.self)
        return observable
    }
}
