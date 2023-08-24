//
//  ViewModel.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 31/03/2023.
//

import Foundation
import RxSwift
import RxCocoa
import RxNetworkKit

class ViewModel {
    // MARK: Input
    // Input sequence is the same as view state (only for loading states)
    private(set) var viewState: PublishRelay<ViewState> = .init()
    // MARK: Output
    private(set) var users: Driver<[Model]>!
    private(set) var error: Driver<NetworkError>!
    // MARK: Properties and Dependencies
    private let networkManager: NetworkManager
    private let disposeBag = DisposeBag()
    /// Creates `ViewModel` instance
    ///
    /// - Parameter networkManager: `NetworkManager` object used for making network API calls.
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        bindOutput()
    }
    /// Creates observable sequence that results in image data.
    ///
    /// - Parameter router: `DownloadRouter` used to download image data.
    ///
    /// - Returns: observable sequence that results in image data.
    func downloadImage(_ router: DownloadRouter) -> Observable<DownloadEvent> {
        networkManager.download(router)
    }
    /// Binds output sequence to input sequence.
    private func bindOutput() {
        // Create default sequence with default API call request.
        let loadObservable = viewState
            .filter( { ![.idle, .loading(loadType: .paginate), .error].contains($0) })
            .flatMapLatest{ _ in
                let single: Single<[Model]> = self.networkManager.request(Router.default)
                return single
                    .asObservable()
                    .materialize()
            }
            .share()
        // Initialize users and error sequence outputs
        self.users = loadObservable
            .compactMap { $0.element }
            .asDriver(onErrorJustReturn: [])
        self.error = loadObservable
            .compactMap { $0.error as? NetworkError }
            .asDriver(onErrorJustReturn: NetworkError.client(.transport(NSError(domain: "", code: 1, userInfo: nil))))
        // Bind output sequence to input sequence (view state)
        self.users
            .asObservable()
            .map({ _ in .idle })
            .bind(to: viewState)
            .disposed(by: disposeBag)
        self.error
            .asObservable()
            .map({ _ in .error })
            .bind(to: viewState)
            .disposed(by: disposeBag)
    }
}
