//
//  Single+Retry.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 27/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

// This extension is inspired by Alex Grebenyuk's excellent blog https://kean.blog/post/smart-retry
// Here's Alex's twitter: https://twitter.com/a_grebenyuk

extension PrimitiveSequence where Trait == SingleTrait, Element: Decodable {
    /// Retries the source `Single` sequence on error using a provided retry
    /// strategy.
    ///
    /// - Parameters:
    ///   - maxAttemptCount: Maximum number of times to repeat the
    ///    sequence. `Int.max` by default.
    ///   - didBecomeReachable: Trigger which is fired when network
    ///   connection becomes reachable.
    ///   - shouldRetry: Always retruns `true` by default.
    ///
    /// - Returns: `Single` sequence with provoded retry strategy applied.
    func retry(_ maxAttemptCount: Int = Int.max,
               delay: NetworkRequestRetryPolicy,
               didBecomeReachable: PublishRelay<Void> = NetworkReachability.shared.didBecomeReachable,
               shouldRetry: @escaping (NetworkError) -> Bool = { _ in true }) -> Single<Element> {
        self
            .retry { (errors: Observable<Error>) in
            return errors.enumerated().flatMap { attempt, error -> Observable<Void> in
                guard let networkError = error as? NetworkError, maxAttemptCount > attempt + 1, shouldRetry(networkError) else {
                    return .error(error)
                }
                let timer = Observable<Int>.timer(
                    RxTimeInterval.milliseconds(Int(delay.makeTimeInterval(attempt + 1))),
                    scheduler: MainScheduler.instance
                ).map { _ in () } // cast to Observable<Void>
                return Observable.merge(timer, didBecomeReachable.asObservable())
            }
        }
    }
}
