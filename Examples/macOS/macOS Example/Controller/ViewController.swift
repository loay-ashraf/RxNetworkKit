//
//  ViewController.swift
//  macOS Example
//
//  Created by Loay Ashraf on 22/08/2023.
//

import Cocoa
import RxSwift
import RxRelay
import RxNetworkKit
import CoreExample

class ViewController: NSViewController {
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var reachbilityView: NSView!
    @IBOutlet weak var reachabilityLabel: NSTextField!
    @IBOutlet weak var errorView: NSStackView!
    @IBOutlet weak var errorImageView: NSImageView!
    @IBOutlet weak var errorLabel: NSTextField!
    @IBOutlet weak var errorRetryButton: NSButton!
    @IBOutlet weak var activityIndicator: NSProgressIndicator!
    private var viewModel: ViewModel!
    private var items: BehaviorRelay<[Model]> = .init(value: [])
    private var refreshItems: PublishRelay<Void> = .init()
    private let disposeBag: DisposeBag = .init()
    /// View has loaded successfully.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        bindUI()
    }
    /// View is about to appear on screen.
    override func viewWillAppear() {
        super.viewWillAppear()
        viewModel.viewState.accept(.loading(loadType: .initial))
    }
    /// called when `Refresh Items` menu items is tapped.
    ///
    /// - Parameter sender: `NSMenuItem` object that sent event.
    @IBAction func refreshItems(_ sender: NSMenuItem) {
        refreshItems.accept(())
    }
    /// Initializes ViewModel object.
    private func setupViewModel() {
        let requestInterceptor = RequestInterceptor()
        let requestEventMointor = RequestEventMonitor()
        let session = Session(configuration: .default, eventMonitor: requestEventMointor)
        let restClient = RESTClient(session: session, requestInterceptor: requestInterceptor)
        let httpClient = HTTPClient(session: session, requestInterceptor: requestInterceptor)
        viewModel = .init(restClient: restClient, httpClient: httpClient)
    }
    /// Sets up views.
    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        reachbilityView.wantsLayer = true
        reachbilityView.layer?.backgroundColor = NSColor.systemIndigo.cgColor
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
        self.reachabilityLabel.stringValue = reachabilityText
        self.reachbilityView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.reachabilityLabel.stringValue = ""
            self.reachbilityView.isHidden = true
        }
    }
    // MARK: UI Events Bindings
    /// Binds view events.
    private func bindUIEvents() {
        // Bind Refresh Items' tap event to viewModel's viewState.
        bindRefreshItemsEvent()
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
            .drive(items)
            .disposed(by: disposeBag)
        items
            .subscribe(onNext: { _ in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    /// Downloads image data to be displayed inside `TableViewCell` object
    ///
    /// - Parameters:
    ///   - url: `URL` used to download image data.
    ///   - cell: `TableViewCell` that the image data will be applied to.
    private func downloadTableViewCellImage(using url: URL, applyTo cell: TableCellView) {
        viewModel.downloadImage(DownloadRequestRouter.default(url: url))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .completedWithData(let data):
                    guard let data = data, let image = NSImage(data: data) else { return }
                    cell.customImageView.image = image
                default:
                    return
                }
            })
            .disposed(by: self.disposeBag)
    }
    /// Bind activityIndicator's isAnimating property to view state.
    private func bindActivityIndicatorIsAnimating() {
        viewModel.viewState
            .map({ $0 == .loading(loadType: .initial) })
            .subscribe(onNext: { shouldAnimate in
                if shouldAnimate {
                    self.activityIndicator.startAnimation(self)
                } else {
                    self.activityIndicator.stopAnimation(self)
                }
            })
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
    /// Bind Refresh Items' tap event to viewModel's viewState.
    private func bindRefreshItemsEvent() {
        refreshItems
            .map({ .loading(loadType: .refresh) })
            .bind(to: viewModel.viewState)
            .disposed(by: disposeBag)
    }
    /// Bind errorView's retryButton to viewModel's viewState.
    private func bindErrorViewRetryEvent() {
        errorRetryButton.rx
            .tap
            .map({ .loading(loadType: .initial) })
            .bind(to: viewModel.viewState)
            .disposed(by: disposeBag)
    }
    /// Navigates to user profile.
    ///
    /// - Parameter url: HTML `URL` to user profile.
    private func navigateToUserProfile(with url: URL) {
        NSWorkspace.shared.open(url)
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        items.value.count
    }
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        130
    }
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let user = items.value[row]
        guard let cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: nil) as? TableCellView else { return nil }
        cellView.customTextField.stringValue = user.login
        downloadTableViewCellImage(using: user.avatarURL, applyTo: cellView)
        return cellView
    }
}

extension ViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(_ notification: Notification) {
        let tableView = notification.object as! NSTableView
        let rowIndex = tableView.selectedRow
        guard rowIndex >= 0 else { return }
        tableView.deselectRow(rowIndex)
        let user = items.value[rowIndex]
        navigateToUserProfile(with: user.htmlURL)
    }
}
