//
//  ViewController.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 16/02/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var downloadedImageView: UIImageView!
    @IBOutlet weak var downloadImageToMemoryButton: UIButton!
    @IBOutlet weak var downloadImageToDiskButton: UIButton!
    @IBOutlet weak var uploadImageFromMemoryButton: UIButton!
    @IBOutlet weak var uploadImageFromDiskButton: UIButton!
    @IBOutlet weak var uploadMultipleImages: UIButton!
    @IBOutlet weak var networkReachabilityStatusLabel: UILabel!
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
    private func downloadImageToMemory(using manager: NetworkManager) {
        let router = TestDownloadRouter.basic(accountId: "FW25b9Z", filePath: "uploads/2023/03/24/person-4BpN.png")
        let downloadObservable: Observable<DownloadEvent> = manager.download(router)
        downloadObservable
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .progress(let progress):
                    print("Image Download Task Progress: \(progress.fractionCompleted*100)%")
                case .completedWithData(let imageData):
                    let image = UIImage(data: imageData!)
                    self.downloadedImageView.image = image
                default: break
                }
            }, onError: {
                print("Image Download Task Failure: \($0.localizedDescription)")
            }, onCompleted: {
                print("Image Download Task Completed!")
            })
            .disposed(by: disposeBag)
    }
    private func downloadImageToDisk(using manager: NetworkManager) {
        let router = TestDownloadRouter.basic(accountId: "FW25b9Z", filePath: "uploads/2023/03/24/person-4BpN.png")
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imageURL = documentsURL.appending(path: "person-d.png")
        let downloadObservable: Observable<DownloadEvent> = manager.download(router, imageURL)
        downloadObservable
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onNext: {
                switch $0 {
                case .progress(let progress):
                    print("Image Download Task Progress: \(progress.fractionCompleted*100)%")
                case .completed:
                    print("Image Download Task Completed!")
                    let imageData = try? Data(contentsOf: imageURL)
                    let image = UIImage(data: imageData!)
                    self.downloadedImageView.image = image
                default: break
                }
            }, onError: {
                print("Image Download Task Failure: \($0.localizedDescription)")
            }, onCompleted: {
                print("Image Download Task Completed!")
            })
            .disposed(by: disposeBag)
    }
    private func uploadImageFromMemory(using manager: NetworkManager) {
        let router = TestUploadRouter.basic(accountId: "FW25b9Z")
        guard let image = UIImage(systemName: "person") else { return }
        guard let imageData = image.pngData() else { return }
        guard let file = UploadFile(forKey: UUID().uuidString, withName: "person.png", withData: imageData) else { return }
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
        guard let file = UploadFile(forKey: UUID().uuidString, withURL: imageURL) else { return }
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
        let files = imageURLs.compactMap { UploadFile(forKey: UUID().uuidString, withURL: $0) }
        let formData = UploadFormData(parameters: parameters, files: files)
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
        let manager = NetworkManager(configuration: .default, requestInterceptor: self, eventMonitor: self)
        let router = TestRouter.test1
        let single: Single<Model> = manager.request(router)
        single
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe(onSuccess: {
                print("Test Task Response: \($0)")
                print("Test Task Completed!")
            }, onFailure: {
                print("Test Task Failure: \($0.localizedDescription)")
            }, onDisposed: {
                print("Subscription is disposed!")
            })
            .disposed(by: disposeBag)
//        let completable: Completable = manager.request(router)
//        completable
//            .observe(on: ConcurrentMainScheduler.instance)
//            .subscribe(onCompleted: {
//                print("Test Task Completed!")
//            }, onError: {
//                print("Test Task Failure: \($0.localizedDescription)")
//            }, onDisposed: {
//                print("Subscription is disposed!")
//            })
//            .disposed(by: disposeBag)
        downloadImageToMemoryButton
            .rx
            .tap
            .bind(onNext: {
                self.downloadImageToMemory(using: manager)
            })
            .disposed(by: disposeBag)
        downloadImageToDiskButton
            .rx
            .tap
            .bind(onNext: {
                self.downloadImageToDisk(using: manager)
            })
            .disposed(by: disposeBag)
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
        NetworkReachability.shared.didChangeStatus
            .observe(on: ConcurrentMainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: {
                switch $0 {
                case .reachable(let interfaceType):
                    self.networkReachabilityStatusLabel.text = "Network is reachable via \(interfaceType.rawValue)."
                case .unReachable:
                    self.networkReachabilityStatusLabel.text = "Network is unreachable."
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ViewController: NetworkEventMonitor {
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
    func urlSession(_ session: URLSession, didCreateTask task: URLSessionTask) {
        debugPrint("Task created!")
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error else { return }
        debugPrint("Task did finish with error: \(error.localizedDescription)!")
    }
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) { }
}

extension ViewController: NetworkRequestInterceptor {
    func adapt(_ request: URLRequest, for session: URLSession) -> URLRequest {
        var request = request
        request.setValue("Bearer public_FW25b9ZFF26sbDfyj9zR8EsHbzA4", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
