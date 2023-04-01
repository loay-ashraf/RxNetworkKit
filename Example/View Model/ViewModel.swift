//
//  ViewModel.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 31/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    // MARK: Input
    private(set) var viewState: PublishRelay<ViewState> = .init()
    // MARK: Output
    private(set) var users: Driver<[UserModel]>!
    private(set) var error: Driver<NetworkError>!
    // MARK: Properties and Dependencies
    private let networkManager: NetworkManager
    private let disposeBag = DisposeBag()
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        bindOutput()
    }
    private func bindOutput() {
        let loadObservable = viewState
            .filter( { ![.idle, .loading(loadType: .paginate), .error].contains($0) })
            .flatMapLatest{ _ in
                let single: Single<[UserModel]> = self.networkManager.request(Router.default)
                return single
                    .asObservable()
                    .materialize()
            }
            .share()
        self.users = loadObservable
            .compactMap { $0.element }
            .asDriver(onErrorJustReturn: [])
        self.error = loadObservable
            .compactMap { $0.error as? NetworkError }
            .asDriver(onErrorJustReturn: NetworkError.client(.transport(NSError(domain: "", code: 1, userInfo: nil))))
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

struct UserModel: Decodable {
    let id: Int
    let avatarURL: URL
    let htmlURL: URL
    let login: String
    enum CodingKeys: String, CodingKey {
        case id
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
        case login
    }
}

enum Router: NetworkRouter {
    case `default`
    var scheme: HTTPScheme {
        .https
    }
    var method: HTTPMethod {
        .get
    }
    var domain: String {
        "api.github.com"
    }
    var path: String {
        "users"
    }
    var headers: [String : String] {
        ["Accept": "application/vnd.github+json"]
    }
    var parameters: [String : String]? {
        nil
    }
    var body: [String : Any]? {
        nil
    }
    var url: URL? {
        let urlString = scheme.rawValue + domain + "/" + path
        return URL(string: urlString)
    }
}
