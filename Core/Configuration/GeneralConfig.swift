// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import UserNotifications

public struct RetryingFailedNetworkRequestsConfig {
    public let shouldRetry: Bool
    public let maxRetryCount: Int
    public let retryingTimeDelay: TimeInterval
}

public protocol GeneralConfig {

    var appName: String { get }

    var acknowledgeServerErrors: Bool { get }
    var acknowledgeHTTPResponseNotFoundErrors: Bool { get }
    var acknowledgeHTTPResponseErrorCodes: Bool { get }
    var retryingFailedNetworkRequests: RetryingFailedNetworkRequestsConfig { get }
    var httpRequestSendUserAgentHeader: Bool { get }
    var httpRequestSendAcceptLanguageHeader: Bool { get }
    var logHTTPResponseData: Bool { get }
    var maxHTTPResponseDataSizeForLogging: Int { get }

    var storeAuthenticationTokensInGlobalKeychain: Bool { get }

    var remoteNotificationsOptions: UNAuthorizationOptions { get }

}

// All environments.
public extension GeneralConfig {

    var appName: String { return UserDefinedBuildSettings.string[#function] }

    var retryingFailedNetworkRequests: RetryingFailedNetworkRequestsConfig {
        return
            RetryingFailedNetworkRequestsConfig(
                shouldRetry: true,
                maxRetryCount: 3,
                retryingTimeDelay: 1)
    }

    var acknowledgeServerErrors: Bool { return true }
    var acknowledgeHTTPResponseNotFoundErrors: Bool { return true }
    var acknowledgeHTTPResponseErrorCodes: Bool { return true }
    var httpRequestSendUserAgentHeader: Bool { return false }
    var httpRequestSendAcceptLanguageHeader: Bool { return false }
    var logHTTPResponseData: Bool { return false }
    var maxHTTPResponseDataSizeForLogging: Int { return 1024 }

    var storeAuthenticationTokensInGlobalKeychain: Bool { return true }

    var remoteNotificationsOptions: UNAuthorizationOptions { return [.alert, .badge, .sound] }

}

// Dev environment.
public struct GeneralConfigDev: GeneralConfig {
    //
}

// Prod environment.
public struct GeneralConfigProd: GeneralConfig {
    //
}
