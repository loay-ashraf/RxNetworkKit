//
//  ViewController.swift
//  tvOS Example
//
//  Created by Loay Ashraf on 10/01/2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import RxNetworkKit
import CoreExample

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var reachbilityView: UIView!
    @IBOutlet weak var reachabilityLabel: UILabel!
    @IBOutlet weak var errorView: UIStackView!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorRetryButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var viewModel: ViewModel!
    private let disposeBag: DisposeBag = .init()
    /// View has loaded successfully.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        bindUI()
    }
    /// View is about to appear on screen.
    ///
    /// - Parameter animated: whether to animate view appearance or not
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewState.accept(.loading(loadType: .initial))
    }
    /// Initializes ViewModel object.
    private func setupViewModel() {
        let requestInterceptor = RequestInterceptor()
        let session = Session(configuration: .default)
        let restClient = RESTClient(session: session, requestInterceptor: requestInterceptor)
        let httpClient = HTTPClient(session: session, requestInterceptor: requestInterceptor)
        viewModel = .init(restClient: restClient, httpClient: httpClient)
    }
    // MARK: - Bindings
    /// Binds view state and events.
    private func bindUI() {
        bindUIState()
        bindUIEvents()
    }
    // MARK: UI State Bindings
    /// Binds view state.
    private func bindUIState() {
        bindTableViewIsHidden()
        bindTableViewItems()
        bindActivityIndicatorIsAnimating()
        bindErrorViewIsHidden()
        bindErrorViewText()
        bindReachabilityText()
    }
    /// Presents new reachability status.
    ///
    /// - Parameter status: `NetworkReachabilityStatus` object to be presented.
    private func presentReachabilityStatus(_ status: NetworkReachabilityStatus) {
        var reachabilityText = ""
        switch status {
        case .reachable(let interfaceType):
            reachabilityText = "Network is reachable via \(interfaceType.rawValue)."
        case .unReachable:
            reachabilityText = "Network is unreachable."
        }
        self.reachabilityLabel.text = reachabilityText
        self.reachbilityView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.reachabilityLabel.text = ""
            self.reachbilityView.isHidden = true
        }
    }
    // MARK: UI Events Bindings
    /// Binds view events.
    private func bindUIEvents() {
        // Bind errorView's retryButton to viewModel's viewState.
        bindErrorViewRetryEvent()
    }
    /// Bind tableView's isHidden property to view state.
    private func bindTableViewIsHidden() {
        viewModel.viewState
            .map({ $0 == .loading(loadType: .initial) || $0 == .error })
            .bind(to: tableView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    /// Bind viewModel's users sequence to tableView's items.
    private func bindTableViewItems() {
        viewModel.users
            .drive(tableView.rx.items(cellIdentifier: "customCell", cellType: TableViewCell.self)) { index, model, cell in
                cell.customTextLabel.text = model.login
                self.downloadTableViewCellImage(using: model.avatarURL, applyTo: cell)
            }
            .disposed(by: disposeBag)
    }
    /// Downloads image data to be displayed inside `TableViewCell` object
    ///
    /// - Parameters:
    ///   - url: `URL` used to download image data.
    ///   - cell: `TableViewCell` that the image data will be applied to.
    private func downloadTableViewCellImage(using url: URL, applyTo cell: TableViewCell) {
        viewModel.downloadImage(DownloadRequestRouter.default(url: url))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .completedWithData(let data):
                    guard let data = data, let image = UIImage(data: data) else { return }
                    cell.customImageView.image = image
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
    /// Bind activityIndicator's isAnimating property to view state.
    private func bindActivityIndicatorIsAnimating() {
        viewModel.viewState
            .map({ $0 == .loading(loadType: .initial) })
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    /// Bind errorView's isHidden property to view state.
    private func bindErrorViewIsHidden() {
        viewModel.viewState
            .map({ $0 != .error })
            .bind(to: errorView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    /// Bind viewModel's error sequence to errorLabel's text.
    private func bindErrorViewText() {
        viewModel.error
            .map({ $0.localizedDescription })
            .drive(errorLabel.rx.text)
            .disposed(by: disposeBag)
    }
    /// Bind NetworkReachability's status sequence to reachabiliytView and reachabilityLabel.
    private func bindReachabilityText() {
        NetworkReachability.shared.status
            .observe(on: MainScheduler.instance)
            .bind(onNext: {
                self.presentReachabilityStatus($0)
            })
            .disposed(by: disposeBag)
    }
    /// Bind errorView's retryButton to viewModel's viewState.
    private func bindErrorViewRetryEvent() {
        errorRetryButton.rx
            .primaryAction
            .map({ .loading(loadType: .initial) })
            .bind(to: viewModel.viewState)
            .disposed(by: disposeBag)
    }
}
