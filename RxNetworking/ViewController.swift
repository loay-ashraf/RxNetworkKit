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
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let manager = NetworkManager(session: session)
        let router = CatFactRouter.fact
//        let single: Single<CatFact> = manager.request(router)
//        single
//            .observe(on: ConcurrentMainScheduler.instance)
//            .subscribe(onSuccess: { debugPrint($0) }, onFailure: { debugPrint($0) })
//            .disposed(by: disposeBag)
        let completable: Completable = manager.request(router)
        completable
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onCompleted: { print(#function, "Completed!") }, onError: { debugPrint($0) })
            .disposed(by: disposeBag)
    }
}

extension ViewController: URLSessionDelegate {
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        debugPrint("")
    }
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping @Sendable (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
       completionHandler(.useCredential, urlCredential)
    }
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        debugPrint(session)
    }
}
