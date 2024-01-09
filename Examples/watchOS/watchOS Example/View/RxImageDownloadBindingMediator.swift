//
//  RxImageDownloadBindingMediator.swift
//  watchOS Example Watch App
//
//  Created by Loay Ashraf on 10/01/2024.
//

import SwiftUI
import RxSwift
import RxNetworkKit

/// This Class mediates and links Rx bindings to SwiftUI bindings
class RxImageDownloadBindingMediator: ObservableObject {
    // MARK: - Properties
    var input: Observable<HTTPDownloadRequestEvent>
    @Published var output: UIImage
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    // MARK: - Initializer
    init(input: Observable<HTTPDownloadRequestEvent>, output: UIImage) {
        self.input = input
        self.output = output
        setupInOutBinding()
    }
    // MARK: - Instance Methods
    private func setupInOutBinding() {
        input
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .completedWithData(let data):
                    guard let data = data, let image = UIImage(data: data) else { return }
                    self?.output = image
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
}
