//
//  NetworkReachability.swift
//  RxNetworkKit
//
//  Created by Loay Ashraf on 28/03/2023.
//

import Foundation
import Network
import RxSwift
import RxCocoa

/// Monitors network reachbility status.
public class NetworkReachability {
    
    /// Shared `NetworkReachability` instance.
    public static let shared: NetworkReachability = .init()
    /// a `BehaviorRelay` object for current reachability status.
    public private(set) var status: BehaviorRelay<NetworkReachabilityStatus> = .init(value: .unReachable)
    /// a `PublishRelay` object that notifies subscribers when network is reachable.
    public private(set) var didBecomeReachable: PublishRelay<Void> = .init()
    private var _status: NetworkReachabilityStatus = .unReachable
    private var monitor: NWPathMonitor
    private let monitorQueue: DispatchQueue
    
    /// Creates a `NetworkReachability` instance.
    private init() {
        self.monitor = .init()
        let bundleID = Bundle.main.bundleIdentifier!
        let monitorQueueLabel = bundleID + ".reachability"
        self.monitorQueue = .init(label: monitorQueueLabel, qos: .utility)
    }
    
    /// Starts network monitor on monitor dispatch queue.
    public func start() {
        monitor.pathUpdateHandler = handlePathUpdate(_:)
        monitor.start(queue: monitorQueue)
    }
    
    /// Stops network monitor.
    public func stop() {
        monitor.cancel()
    }
    
    /// Sets interface types to monitor by creating new `NWPathMonitor` instance,
    /// Call `start` method after calling this method.
    ///
    /// - Parameter types: `[NetworkInterfaceType]` array of desired interface types to be monitored.
    public func setInterfaceTypes(_ types: [NetworkInterfaceType]) {
        let allTypesSet: Set<NWInterface.InterfaceType> = Set(NWInterface.InterfaceType.allCases)
        let allowedTypesSet: Set<NWInterface.InterfaceType> = Set(types)
        let prohibtedTypesSet: Set<NWInterface.InterfaceType> = allTypesSet.subtracting(allowedTypesSet)
        let prohibtedTypes: [NWInterface.InterfaceType] = Array(prohibtedTypesSet)
        let newMonitor = NWPathMonitor(prohibitedInterfaceTypes: prohibtedTypes)
        monitor = newMonitor
    }
    
    /// Handles netwok path updates and sends events to relays.
    ///
    /// - Parameter path: updated `NWPath` object.
    private func handlePathUpdate(_ path: NWPath) {
        let newStatus = NetworkReachabilityStatus(path: path)
        // Make sure new status doesn't equal current one to avoid duplicate events
        // This technique is used as we cannot use `distinctUntilChanged` operator
        // on `BehaviorRelay` observable.
        guard newStatus != _status else { return }
        _status = newStatus
        // Send events via exposed relay observables.
        status.accept(newStatus)
        if case .reachable = newStatus {
            didBecomeReachable.accept(())
        }
    }
    
}
