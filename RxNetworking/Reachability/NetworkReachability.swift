//
//  NetworkReachability.swift
//  RxNetworking
//
//  Created by Loay Ashraf on 28/03/2023.
//

import Foundation
import SystemConfiguration
import Network
import RxSwift
import RxCocoa

typealias NetworkInterfaceType = NWInterface.InterfaceType

enum NetworkReachabilityStatus: Equatable {
    case reachable(interfaceType: NetworkInterfaceType)
    case unReachable
}

class NetworkReachability {
    static let shared: NetworkReachability = .init()
    var didChangeStatus: BehaviorRelay<NetworkReachabilityStatus> = .init(value: .unReachable)
    var didBecomeReachable: PublishRelay<Void> = .init()
    private var monitor: NWPathMonitor
    private let monitorQueue: DispatchQueue
    private init() {
        self.monitor = .init()
        let bundleID = Bundle.main.bundleIdentifier!
        let monitorQueueLabel = bundleID + ".reachability"
        self.monitorQueue = .init(label: monitorQueueLabel, qos: .utility)
    }
    func start() {
        monitor.pathUpdateHandler = handlePathUpdate(_:)
        monitor.start(queue: monitorQueue)
    }
    func stop() {
        monitor.cancel()
    }
    func setInterfaceTypes(_ types: [NetworkInterfaceType]) {
        let allTypesSet: Set<NWInterface.InterfaceType> = Set(NWInterface.InterfaceType.allCases)
        let allowedTypesSet: Set<NWInterface.InterfaceType> = Set(types)
        let prohibetedTypesSet: Set<NWInterface.InterfaceType> = allTypesSet.subtracting(allowedTypesSet)
        let prohiptedTypes: [NWInterface.InterfaceType] = Array(prohibetedTypesSet)
        let newMonitor = NWPathMonitor(prohibitedInterfaceTypes: prohiptedTypes)
        monitor = newMonitor
    }
    private func handlePathUpdate(_ path: NWPath) {
        let status = path.status
        switch status {
        case .satisfied:
            let interfaceType = path.interfaceType
            self.didChangeStatus.accept(.reachable(interfaceType: interfaceType))
            self.didBecomeReachable.accept(())
            print("Network is reachable via \(interfaceType.rawValue).")
        default:
            self.didChangeStatus.accept(.unReachable)
            print("Network is unreachable.")
        }
    }
}

extension NWInterface.InterfaceType: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case "Other":
            self = .other
        case "Wifi":
            self = .wifi
        case "Cellular":
            self = .cellular
        case "Ethernet":
            self = .wiredEthernet
        case "Loopback":
            self = .loopback
        default:
            return nil
        }
    }
    public var rawValue: String {
        switch self {
        case .other: return "Other"
        case .wifi: return "Wifi"
        case .cellular: return "Cellular"
        case .wiredEthernet: return "Ethernet"
        case .loopback: return "Loopback"
        @unknown default: return "Unsupported"
        }
    }
}
