// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

// MARK: - Protocol

public protocol ErrorManagerProtocol {
    func handleError(_ error: E)
}

// MARK: - Implementation

public final class ErrorManager: ErrorManagerProtocol, SharedInstance {

    public typealias InstanceProtocol = ErrorManagerProtocol
    public static let defaultInstance: InstanceProtocol = ErrorManager()

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Error handling

    public func handleError(_ error: E) {
        //
    }

}
