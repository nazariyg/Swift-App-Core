// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import ReactiveSwift
import Result
import ReactiveCocoa

/// It's sufficient for conforming classes to contain a nested `Request` type, without the need of typealiasing. Requests can be listened on
/// through `requestSignal` property and emitted through `requestEmitter` property.
public protocol RequestEmitter: StoredProperties {
    associatedtype Request
}

private struct StoredPropertyKeys {
    static let requestEmitterIsInitialized = "requestEmitterIsInitialized"
    static let requestSignal = "requestSignal"
    static let requestEmitter = "requestEmitter"
}

public extension RequestEmitter {

    var requestSignal: Si<Request> {
        let (signal, _) = initializeOrGetPipe()
        return signal
    }

    var requestEmitter: Ob<Request> {
        let (_, emitter) = initializeOrGetPipe()
        return emitter
    }

    private func initializeOrGetPipe() -> (signal: Si<Request>, emitter: Ob<Request>) {
        return synchronized(self) {
            if let isInitialized = sp.bool[StoredPropertyKeys.requestEmitterIsInitialized], isInitialized {
                let signal = sp.any[StoredPropertyKeys.requestSignal] as! Si<Request>
                let emitter = sp.any[StoredPropertyKeys.requestEmitter] as! Ob<Request>
                return (signal, emitter)
            } else {
                let (newSignal, newEmitter) = Si<Request>.pipe()
                sp.any[StoredPropertyKeys.requestSignal] = newSignal
                sp.any[StoredPropertyKeys.requestEmitter] = newEmitter
                sp.bool[StoredPropertyKeys.requestEmitterIsInitialized] = true
                return (newSignal, newEmitter)
            }
        }
    }

}
