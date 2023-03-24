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
    @IBOutlet weak var uploadMultipleImages: UIButton!
    private let disposeBag: DisposeBag = .init()
    private func writeLocalFiles() {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let personImageURL = documentsURL.appending(path: "person.png")
        let personFillImageURL = documentsURL.appending(path: "person-fill.png")
        let globeImageURL = documentsURL.appending(path: "globe.png")
        let folderImageURL = documentsURL.appending(path: "folder.png")
        let folderFillImageURL = documentsURL.appending(path: "folder-fill.png")
        guard !fileManager.fileExists(atPath: personImageURL.path()) ||
              !fileManager.fileExists(atPath: personFillImageURL.path()) ||
              !fileManager.fileExists(atPath: globeImageURL.path()) ||
              !fileManager.fileExists(atPath: folderImageURL.path()) ||
              !fileManager.fileExists(atPath: folderFillImageURL.path()) else { return }
        guard let personData = UIImage(systemName: "person")?.pngData(),
              let personFillData = UIImage(systemName: "person.fill")?.pngData(),
              let globeData = UIImage(systemName: "globe")?.pngData(),
              let folderData = UIImage(systemName: "folder")?.pngData(),
              let folderFillData = UIImage(systemName: "folder.fill")?.pngData() else { return }
        try? personData.write(to: personImageURL)
        try? personFillData.write(to: personFillImageURL)
        try? globeData.write(to: globeImageURL)
        try? folderData.write(to: folderImageURL)
        try? folderFillData.write(to: folderFillImageURL)
    }
    private func uploadImageFromMemory(using manager: NetworkManager) {
        let router = TestUploadRouter.basic(accountId: "FW25b9Z")
        guard let image = UIImage(systemName: "person") else { return }
        guard let imageData = image.pngData() else { return }
        let file = File(forKey: UUID().uuidString, withName: "person.png", withData: imageData, withMimeType: "image/png")
        let uploadObservable: Observable<UploadEvent<UploadModel>> = manager.upload(router, file)
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
            .disposed(by: disposeBag)
    }
    private func uploadImageFromDisk(using manager: NetworkManager) {
        let router = TestUploadRouter.basic(accountId: "FW25b9Z")
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imageURL = documentsURL.appending(path: "person.png")
        let file = File(forKey: UUID().uuidString, withURL: imageURL, withMimeType: "image/png")
        let uploadObservable: Observable<UploadEvent<UploadModel>> = manager.upload(router, file)
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
            .disposed(by: disposeBag)
    }
    private func uploadMultipleImages(using manager: NetworkManager) {
        let router = TestUploadRouter.formData(accountId: "FW25b9Z")
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let parameters = ["name": "Test Upload",
                          "id": "\(UUID().uuidString)"]
        let imageURLs = [documentsURL.appending(path: "person.png"),
                         documentsURL.appending(path: "person-fill.png"),
                         documentsURL.appending(path: "globe.png"),
                         documentsURL.appending(path: "folder.png"),
                         documentsURL.appending(path: "folder-fill.png")]
        let files = imageURLs.compactMap { File(forKey: UUID().uuidString, withURL: $0, withMimeType: "image/png") }
        let formData = FormData(parameters: parameters, files: files)
        let uploadObservable: Observable<UploadEvent<FormUploadModel>> = manager.upload(router, formData)
        uploadObservable
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .progress(let progress):
                    print("Multi-Image Upload Task Progress: \(progress.fractionCompleted*100)%")
                case .completed(let model):
                    print("Multi-Image Upload Task Response: \(model)")
                }
            }, onError: {
                print("Multi-Image Upload Task Failure: \($0.localizedDescription)")
            }, onCompleted: {
                print("Multi-Image Upload Task Completed!")
            })
            .disposed(by: disposeBag)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        writeLocalFiles()
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
        uploadMultipleImages
            .rx
            .tap
            .bind(onNext: {
                self.uploadMultipleImages(using: manager)
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController: URLSessionDelegate, URLSessionTaskDelegate {
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
