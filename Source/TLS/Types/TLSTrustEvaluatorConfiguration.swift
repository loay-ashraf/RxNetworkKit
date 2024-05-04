//
//  TLSTrustEvaluatorConfiguration.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 04/05/2024.
//

import Foundation

public class TLSTrustEvaluatorConfiguration {
    
    public static var `default`: TLSTrustEvaluatorConfiguration {
        .init()
    }
    
    public var evaluationPolicies: [String: TLSTrustEvaluationPolicy] = [:]
    public var evaluateAllHosts: Bool = true
    
}
