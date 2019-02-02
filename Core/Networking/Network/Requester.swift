// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import Alamofire
import ReactiveSwift

// MARK: - Protocol

public protocol RequesterProtocol {
    var stateless: Reactive<SessionManager> { get }
    var statefulCacheless: Reactive<SessionManager> { get }
    var stateful: Reactive<SessionManager> { get }
    var background: Reactive<SessionManager> { get }
    static func makeStateless(baseConfiguration: URLSessionConfiguration?) -> Reactive<SessionManager>
    static func makeStatefulCacheless(baseConfiguration: URLSessionConfiguration?) -> Reactive<SessionManager>
    static func makeStateful(baseConfiguration: URLSessionConfiguration?) -> Reactive<SessionManager>
    static func makeBackground(baseConfiguration: URLSessionConfiguration?) -> Reactive<SessionManager>
    static var defaultBaseConfiguration: URLSessionConfiguration { get }
}

// MARK: - Implementation

/// Request dispatchers are represented by `URLSession` instances with reactive extensions.
public final class Requester: RequesterProtocol, SharedInstance {

    public typealias InstanceProtocol = RequesterProtocol
    public static let defaultInstance: InstanceProtocol = Requester()

    // MARK: - Lifecycle

    private init() {}

    // MARK: - Session managers

    /// Does not use cache and does not permanently store any cookies or credentials to disk.
    public let stateless: Reactive<SessionManager> = {
        return Self.makeStateless()
    }()

    /// Does not use cache but permanently stores cookies and credentials.
    public let statefulCacheless: Reactive<SessionManager> = {
        return Self.makeStatefulCacheless()
    }()

    /// Does use cache and permanently stores cookies and credentials.
    public let stateful: Reactive<SessionManager> = {
        return Self.makeStateful()
    }()

    /// Downloads data in background, does use cache.
    public let background: Reactive<SessionManager> = {
        return Self.makeBackground()
    }()

    // MARK: - Factory

    /// Does not use cache and does not permanently store any cookies or credentials to disk.
    public static func makeStateless(baseConfiguration: URLSessionConfiguration? = nil) -> Reactive<SessionManager> {
        let configuration: URLSessionConfiguration
        if let baseConfiguration = baseConfiguration {
            configuration = baseConfiguration
        } else {
            configuration = URLSessionConfiguration.ephemeral

            // Copy headers from the default configuration.
            configuration.httpAdditionalHeaders = defaultBaseConfiguration.httpAdditionalHeaders
        }

        // Disable caching completely.
        configuration.disableCaching()

        let sessionManager = SessionManager(configuration: configuration, serverTrustPolicyManager: defaultServerTrustPolicyManager)
        sessionManager.startRequestsImmediately = false

        if Config.shared.general.retryingFailedNetworkRequests.shouldRetry {
            sessionManager.retrier = HTTPRequestRetrier()
        }

        return sessionManager.reactive
    }

    /// Does not use cache but permanently stores cookies and credentials.
    public static func makeStatefulCacheless(baseConfiguration: URLSessionConfiguration? = nil) -> Reactive<SessionManager> {
        let configuration: URLSessionConfiguration
        if let baseConfiguration = baseConfiguration {
            configuration = baseConfiguration
        } else {
            configuration = defaultBaseConfiguration
        }

        // Disable caching completely.
        configuration.disableCaching()

        let sessionManager = SessionManager(configuration: configuration, serverTrustPolicyManager: defaultServerTrustPolicyManager)
        sessionManager.startRequestsImmediately = false

        if Config.shared.general.retryingFailedNetworkRequests.shouldRetry {
            sessionManager.retrier = HTTPRequestRetrier()
        }

        return sessionManager.reactive
    }

    /// Does use cache and permanently stores cookies and credentials.
    public static func makeStateful(baseConfiguration: URLSessionConfiguration? = nil) -> Reactive<SessionManager> {
        let configuration: URLSessionConfiguration
        if let baseConfiguration = baseConfiguration {
            configuration = baseConfiguration
        } else {
            configuration = defaultBaseConfiguration
        }

        let sessionManager = SessionManager(configuration: configuration, serverTrustPolicyManager: defaultServerTrustPolicyManager)
        sessionManager.startRequestsImmediately = false

        if Config.shared.general.retryingFailedNetworkRequests.shouldRetry {
            sessionManager.retrier = HTTPRequestRetrier()
        }

        return sessionManager.reactive
    }

    /// Downloads data in background, does use cache.
    public static func makeBackground(baseConfiguration: URLSessionConfiguration? = nil) -> Reactive<SessionManager> {
        let configuration: URLSessionConfiguration
        if let baseConfiguration = baseConfiguration {
            configuration = baseConfiguration
        } else {
            let configurationID = "\(Bundle.mainBundleID).URLSessionConfiguration.background"
            configuration = URLSessionConfiguration.background(withIdentifier: configurationID)

            // Copy headers from the default configuration.
            configuration.httpAdditionalHeaders = defaultBaseConfiguration.httpAdditionalHeaders
        }

        let sessionManager = SessionManager(configuration: configuration, serverTrustPolicyManager: defaultServerTrustPolicyManager)
        sessionManager.startRequestsImmediately = false

        if Config.shared.general.retryingFailedNetworkRequests.shouldRetry {
            sessionManager.retrier = HTTPRequestRetrier()
        }

        return sessionManager.reactive
    }

    public static let defaultBaseConfiguration: URLSessionConfiguration = {
        let configuration = SessionManager.default.session.configuration

        if !Config.shared.general.httpRequestSendUserAgentHeader {
            configuration.removeHeader(header: HTTPHeader.Request.userAgent)
        }

        if !Config.shared.general.httpRequestSendAcceptLanguageHeader {
            configuration.removeHeader(header: HTTPHeader.Request.acceptLanguage)
        }

        return configuration
    }()

    // MARK: - Private

    private typealias `Self` = Requester

    private static var defaultServerTrustPolicyManager: ServerTrustPolicyManager? = {
        let disableEvaluationDomains = Config.shared.backend.serverTrustPolicyDisableEvaluationDomains
        guard disableEvaluationDomains.isNotEmpty else { return nil }
        let serverTrustPolicies =
            [String: ServerTrustPolicy](uniqueKeysWithValues:
                disableEvaluationDomains.map { ($0, .disableEvaluation) })
        let serverTrustPolicyManager = ServerTrustPolicyManager(policies: serverTrustPolicies)
        return serverTrustPolicyManager
    }()

}

private extension URLSessionConfiguration {

    func disableCaching() {
        urlCache = nil
        requestCachePolicy = .reloadIgnoringLocalCacheData
    }

    func removeHeader(header: HTTPHeader.Request) {
        httpAdditionalHeaders?.removeValue(forKey: header.value)
    }

}
