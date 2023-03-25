//
//  Reactive+URLSessionAdaptedDownloadResponse.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 25/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: URLSession {
    func downloadResponse<AE: NetworkAPIError>(request: URLRequest, apiErrorType: AE.Type) -> Observable<DownloadEvent> {
        let observables = downloadResponse(request: request)
        let progressObservable = observables
            .0
            .map { DownloadEvent.progress(progress: $0) }
            .asObservable()
        let responseObservable = observables
            .1
            .decodable(AE.self)
            .map { DownloadEvent.completedWithData(data: $0.data) }
            .asObservable()
        let mergedObservable = responseObservable.merge(with: progressObservable)
        return mergedObservable
    }
    func downloadResponse<AE: NetworkAPIError>(request: URLRequest, saveTo url: URL, apiErrorType: AE.Type) -> Observable<DownloadEvent> {
        let observables = downloadResponse(request: request, saveTo: url)
        let progressObservable = observables
            .0
            .map { DownloadEvent.progress(progress: $0) }
            .asObservable()
        let responseObservable = observables
            .1
            .decodable(AE.self)
            .map { _ in DownloadEvent.completed }
            .asObservable()
        let mergedObservable = responseObservable.merge(with: progressObservable)
        return mergedObservable
    }
}
