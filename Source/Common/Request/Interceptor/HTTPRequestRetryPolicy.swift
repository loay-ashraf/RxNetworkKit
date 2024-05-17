//
//  HTTPRequestRetryPolicy.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 27/03/2023.
//

import Foundation

// This enum is inspired by Alex Grebenyuk excellent blog https://kean.blog/post/smart-retry
// Here's Alex's twitter: https://twitter.com/a_grebenyuk

/// Policy for retrying failed requests.
public enum HTTPRequestRetryPolicy {
    case immediate
    case constant(time: Double)
    case exponential(initial: Double, multiplier: Double, maxDelay: Double)
    case custom(closure: (Int) -> Double)
}

public extension HTTPRequestRetryPolicy {
    /// Creates time interavel (`Double`) from current policy and given attempt count.
    ///
    /// - Parameter attempt: current attempt count.
    ///
    /// - Returns: Time interval `Double` for delay.
    func makeTimeInterval(_ attempt: Int) -> Double {
        switch self {
        case .immediate: return 0.0
        case .constant(let time): return time
        case .exponential(let initial, let multiplier, let maxDelay):
            // if it's first attempt, simply use initial delay, otherwise calculate delay
            let delay = attempt == 1 ? initial : initial * pow(multiplier, Double(attempt - 1))
            return min(maxDelay, delay)
        case .custom(let closure): return closure(attempt)
        }
    }
}
