//
//  TLSTrustEvaluatorConfiguration.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

/// Configuration object for TLS server trust evaluator.
public class TLSTrustEvaluatorConfiguration {
    
    /// Default `TLSTrustEvaluatorConfiguration` object.
    public static var `default`: TLSTrustEvaluatorConfiguration {
        .init()
    }
    
    /// `[String: TLSTrustEvaluationPolicy]` dictionary of TLS server trust evaluation policy for each host.
    public var evaluationPolicies: [String: TLSTrustEvaluationPolicy] = [:]
    /// `Bool` flag that indicates whether a `TLSTrustEvaluator` should evaluate all hosts even the ones that do not have a policy specified.
    public var evaluateAllHosts: Bool = true
    
}
