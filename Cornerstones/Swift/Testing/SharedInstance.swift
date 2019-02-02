// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

/// The protocol to be adopted by any class with a shared instance.
/// The conforming class must typealias `InstanceProtocol` to its interface protocol.
public protocol SharedInstance {
    associatedtype InstanceProtocol
    static var defaultInstance: InstanceProtocol { get }
}

public extension SharedInstance {

    /// Asks `SharedInstanceProvider` for the currently set shared instance or returns the default one.
    static var shared: InstanceProtocol {
        if TestingDetector.isNotTesting {
            return defaultInstance
        }
        return InstanceProvider.shared.instance(for: InstanceProtocol.self, defaultInstance: defaultInstance)
    }

}
