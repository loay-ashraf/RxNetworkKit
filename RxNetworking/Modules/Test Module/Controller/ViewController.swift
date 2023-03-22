//
//  ViewController.swift
//  RXNetworking
//
//  Created by Loay Ashraf on 16/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var uploadImageFromMemoryButton: UIButton!
    @IBOutlet weak var uploadImageFromDiskButton: UIButton!
    private let disposeBag: DisposeBag = .init()
    private func writeLocalImage() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imageURL = documentsURL.appending(path: "person.png")
        guard !fileManager.fileExists(atPath: imageURL.absoluteString) else { return }
        guard let data = UIImage(systemName: "person")?.pngData() else { return }
        try? data.write(to: imageURL)
    }
    private func uploadImageFromMemory(using manager: NetworkManager) {
        let router = TestUploadRouter.basic(accountId: "FW25b9Z")
        guard let image = UIImage(systemName: "person") else { return }
        guard let imageData = image.pngData() else { return }
        let uploadObservable: Observable<UploadEvent<TestUploadModel>> = manager.upload(router, imageData)
        uploadObservable
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .progress(let progress):
                    print("Image Upload Task Progress: \(progress.fractionCompleted*100)%")
                case .completed(let model):
                    print("Image Upload Task Response: \(model)")
                }
            }, onError: {
                print("Image Upload Task Failure: \($0.localizedDescription)")
            }, onCompleted: {
                print("Image Upload Task Completed!")
            })
            .disposed(by: self.disposeBag)
    }
    private func uploadImageFromDisk(using manager: NetworkManager) {
        let router = TestUploadRouter.basic(accountId: "FW25b9Z")
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imageURL = documentsURL.appending(path: "person.png")
        let uploadObservable: Observable<UploadEvent<TestUploadModel>> = manager.upload(router, imageURL)
        uploadObservable
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .progress(let progress):
                    print("Image Upload Task Progress: \(progress.fractionCompleted*100)%")
                case .completed(let model):
                    print("Image Upload Task Response: \(model)")
                }
            }, onError: {
                print("Image Upload Task Failure: \($0.localizedDescription)")
            }, onCompleted: {
                print("Image Upload Task Completed!")
            })
            .disposed(by: self.disposeBag)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        writeLocalImage()
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        let manager = NetworkManager(session: session)
        uploadImageFromMemoryButton
            .rx
            .tap
            .bind(onNext: {
                self.uploadImageFromMemory(using: manager)
            })
            .disposed(by: disposeBag)
        uploadImageFromDiskButton
            .rx
            .tap
            .bind(onNext: {
                self.uploadImageFromDisk(using: manager)
            })
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
