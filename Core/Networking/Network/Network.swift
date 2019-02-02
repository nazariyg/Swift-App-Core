// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import Alamofire

public typealias NetworkStatus = NetworkReachabilityManager.NetworkReachabilityStatus
public typealias NetworkConnectionType = NetworkReachabilityManager.ConnectionType

// MARK: - Protocol

public protocol NetworkProtocol {
    var isOnline: Pr<Bool> { get }
    var eventSignal: Si<Network.Event> { get }  // NetworkEventEmitterProtocol
}

// MARK: - Implementation

private let logCategory = "Network"

public final class Network: NetworkProtocol, EventEmitter, SharedInstance {

    public enum Event: Equatable {
        case isOnline(connectionType: NetworkConnectionType)
        case isOffline
    }

    public typealias InstanceProtocol = NetworkProtocol
    public static let defaultInstance: InstanceProtocol = Network()

    /// Skipping repeats.
    private let _isOnline = Mp<Bool>(false)
    public var isOnline: Pr<Bool> {
        return _isOnline.skipRepeats()
    }

    private var reachabilityManager: NetworkReachabilityManager?

    // MARK: - Lifecycle

    private init() {
        log.debug("Initializing the network", logCategory)
        startListeningOnReachability()
    }

    // MARK: - Network status

    private func startListeningOnReachability() {
        if let reachabilityManager = NetworkReachabilityManager() {
            self.reachabilityManager = reachabilityManager
            reachabilityManager.listener = { [weak self] status in
                self?.reachabilityStatusDidChange(toStatus: status)
            }
            reachabilityManager.startListening()
        } else {
            log.error("Could not instantiate a reachability manager", logCategory)
        }
    }

    private func reachabilityStatusDidChange(toStatus status: NetworkStatus) {
        switch status {
        case .reachable(let connectionType):
            log.info("Online. Connected over \(connectionType).", logCategory)
            _isOnline.value = true
            eventEmitter.send(value: .isOnline(connectionType: connectionType))
        case .notReachable:
            log.info("Offline", logCategory)
            _isOnline.value = false
            eventEmitter.send(value: .isOffline)
        case .unknown:
            log.warning("Internet reachability status is unknown", logCategory)
        }
    }

}

extension NetworkReachabilityManager.ConnectionType: CustomStringConvertible {

    public var description: String {
        switch self {
        case .ethernetOrWiFi:
            return "WiFi"
        case .wwan:
            return "WWAN"
        }
    }

}
