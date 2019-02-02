// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

// MARK: - Protocol

public protocol BackendAPIRequestPluginProviderProtocol {

    // Input.
    func addHTTPRequestMapper(_ mapper: BackendAPIRequestPluginHTTPRequestMapper)
    func addHTTPDataResponseObserver(_ observer: BackendAPIRequestPluginHTTPDataResponseObserver)
    func addHTTPResponseErrorObserver(_ observer: BackendAPIRequestPluginHTTPResponseErrorObserver)

    // Output.
    func mapHTTPRequest(_ request: HTTPRequest) -> HTTPRequest
    func onHTTPResponse(_ response: HTTPDataResponse)
    func onHTTPResponseError(_ error: E, request: HTTPRequest)

}

// MARK: - Plugin protocols

public protocol BackendAPIRequestPluginHTTPRequestMapper {
    func mapHTTPRequest(_ request: HTTPRequest) -> HTTPRequest
}

public protocol BackendAPIRequestPluginHTTPDataResponseObserver {
    func onHTTPResponse(_ response: HTTPDataResponse)
}

public protocol BackendAPIRequestPluginHTTPResponseErrorObserver {
    func onHTTPResponseError(_ error: E, request: HTTPRequest)
}

// MARK: - Implementation

public final class BackendAPIRequestPluginProvider: BackendAPIRequestPluginProviderProtocol, SharedInstance {

    public typealias InstanceProtocol = BackendAPIRequestPluginProviderProtocol
    public static let defaultInstance: InstanceProtocol = BackendAPIRequestPluginProvider()

    private var httpRequestMappers: [BackendAPIRequestPluginHTTPRequestMapper] = []
    private var httpDataResponseObservers: [BackendAPIRequestPluginHTTPDataResponseObserver] = []
    private var httpResponseErrorObservers: [BackendAPIRequestPluginHTTPResponseErrorObserver] = []

    private let httpRequestMappersLock = VoidObject()
    private let httpDataResponseObserversLock = VoidObject()
    private let httpResponseErrorObserversLock = VoidObject()

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Request mapping

    public func addHTTPRequestMapper(_ mapper: BackendAPIRequestPluginHTTPRequestMapper) {
        synchronized(httpRequestMappersLock) {
            httpRequestMappers.append(mapper)
        }
    }

    public func mapHTTPRequest(_ request: HTTPRequest) -> HTTPRequest {
        return synchronized(httpRequestMappersLock) {
            return httpRequestMappers.reduce(request) { result, mapper in mapper.mapHTTPRequest(result) }
        }
    }

    // MARK: - Response observing

    public func addHTTPDataResponseObserver(_ observer: BackendAPIRequestPluginHTTPDataResponseObserver) {
        synchronized(httpDataResponseObserversLock) {
            httpDataResponseObservers.append(observer)
        }
    }

    public func onHTTPResponse(_ response: HTTPDataResponse) {
        synchronized(httpDataResponseObserversLock) {
            httpDataResponseObservers.forEach { observer in observer.onHTTPResponse(response) }
        }
    }

    public func addHTTPResponseErrorObserver(_ observer: BackendAPIRequestPluginHTTPResponseErrorObserver) {
        synchronized(httpResponseErrorObserversLock) {
            httpResponseErrorObservers.append(observer)
        }
    }

    public func onHTTPResponseError(_ error: E, request: HTTPRequest) {
        synchronized(httpResponseErrorObserversLock) {
            httpResponseErrorObservers.forEach { observer in observer.onHTTPResponseError(error, request: request) }
        }
    }

}
