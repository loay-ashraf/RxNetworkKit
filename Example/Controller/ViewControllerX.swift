//
//  ViewControllerX.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 31/03/2023.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import SafariServices

enum ViewState: Equatable {
    case idle
    case loading(loadType: LoadType)
    case error
}

enum LoadType {
    case initial
    case refresh
    case paginate
}

class ViewControllerX: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorRetryButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var refreshControl: UIRefreshControl!
    private var viewModel: ViewModel!
    private let disposeBag: DisposeBag = .init()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViewModel()
        setupUI()
        bindUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewState.accept(.loading(loadType: .initial))
    }
    private func setupViewModel() {
        let manager = NetworkManager(configuration: .default, requestInterceptor: self, eventMonitor: self)
        viewModel = .init(networkManager: manager)
    }
    private func setupUI() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
    }
    private func bindUI() {
        bindUIState()
        bindUIEvents()
    }
    private func bindUIState() {
        viewModel.viewState
            .map({ $0 == .loading(loadType: .initial) || $0 == .error })
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.viewState
            .map({ $0 == .loading(loadType: .initial) })
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        viewModel.viewState
            .map({ $0 == .loading(loadType: .refresh) })
            .bind(to: refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        viewModel.viewState
            .map({ $0 != .error })
            .bind(to: errorView.rx.isHidden)
            .disposed(by: disposeBag)
        viewModel.users
            .drive(tableView.rx.items(cellIdentifier: "customCell", cellType: CustomTableViewCell.self)) { index, model, cell in
                cell.customImageView.kf.setImage(with: model.avatarURL)
                cell.customTextLabel.text = model.login
            }
            .disposed(by: disposeBag)
        viewModel.error
            .map({ $0.localizedDescription })
            .drive(errorLabel.rx.text)
            .disposed(by: disposeBag)
    }
    private func bindUIEvents() {
        let itemSelected = tableView.rx
            .itemSelected
        let modelSelected = tableView.rx
            .modelSelected(UserModel.self)
        let rowSelected =
        Observable.zip(itemSelected, modelSelected)
        rowSelected
            .bind(onNext: { selctedIndex, selectedModel in
                self.tableView.deselectRow(at: selctedIndex, animated: true)
                self.navigateToUserProfile(with: selectedModel.htmlURL)
            })
            .disposed(by: disposeBag)
        refreshControl.rx
            .controlEvent(.valueChanged)
            .map({ .loading(loadType: .refresh) })
            .bind(to: viewModel.viewState)
            .disposed(by: disposeBag)
        errorRetryButton.rx
            .tap
            .map({ .loading(loadType: .initial) })
            .bind(to: viewModel.viewState)
            .disposed(by: disposeBag)
    }
}

extension ViewControllerX {
    private func navigateToUserProfile(with url: URL) {
        let safariVC = SFSafariViewController(url: url)
        self.present(safariVC, animated: true, completion: nil)
    }
}

extension ViewControllerX: NetworkEventMonitor {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        debugPrint("")
    }
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        debugPrint(session)
    }
    func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        debugPrint("Task created!")
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error else { return }
        debugPrint("Task did finish with error: \(error.localizedDescription)!")
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) { }
}

extension ViewControllerX: NetworkRequestInterceptor {
    func adapt(_ request: URLRequest, for session: URLSession) -> URLRequest {
        return request
    }
    func retryMaxAttempts(_ request: URLRequest, for session: URLSession) -> Int {
        5
    }
    func retryPolicy(_ request: URLRequest, for session: URLSession) -> NetworkRequestRetryPolicy {
        .constant(time: 5_000)
    }
    func shouldRetry(_ request: URLRequest, for session: URLSession, dueTo error: NetworkError) -> Bool {
        true
    }
}

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var customTextLabel: UILabel!
    @IBOutlet weak var customImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        customImageView.layer.cornerRadius = 50.0
        customImageView.layer.cornerCurve = .continuous
    }
}
