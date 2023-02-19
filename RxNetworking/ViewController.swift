//
//  ViewController.swift
//  RXNetworking
//
//  Created by Loay Ashraf on 16/02/2023.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let session = URLSession(configuration: .default)
        let manager = NetworkManager(session: session)
        let router = CatFactRouter.fact
        let maybe: Single<CatFact> = manager.request(router, EmptyNetworkAPIError.self)
        maybe
            .subscribe(onSuccess: { debugPrint($0) }, onFailure: { debugPrint($0) })
            .disposed(by: disposeBag)
    }
}

