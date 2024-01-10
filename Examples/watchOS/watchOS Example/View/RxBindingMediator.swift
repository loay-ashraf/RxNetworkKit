//
//  RxBindingMediator.swift
//  watchOS Example Watch App
//
//  Created by Loay Ashraf on 10/01/2024.
//

import SwiftUI
import RxSwift
import RxCocoa
import RxNetworkKit

/// This Class mediates and links Rx bindings to SwiftUI bindings
class RxBindingMediator<T>: ObservableObject {
    // MARK: - Properties
    var input: Driver<T>
    @Published var output: T
    // MARK: - Private Properties
    private let disposeBag = DisposeBag()
    // MARK: - Initializer
    init(input: Driver<T>, output: T) {
        self.input = input
        self.output = output
        setupInOutBinding()
    }
    // MARK: - Instance Methods
    private func setupInOutBinding() {
        input
            .drive(onNext: { [weak self] in
                self?.output = $0
            })
            .disposed(by: disposeBag)
    }
}
