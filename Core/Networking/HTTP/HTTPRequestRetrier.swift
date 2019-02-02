// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Alamofire

private let logCategory = "Network"

public struct HTTPRequestRetrier {

    private static let retryingRequestsConfig = Config.shared.general.retryingFailedNetworkRequests

    public func shouldRetryRequest(withRetryCount retryCount: Int, isNetworkError: Bool, responseStatusCode: Int?) -> Bool {
        // In any case, only retry a limited number of times.
        if retryCount >= Self.retryingRequestsConfig.maxRetryCount {
            return false
        }

        // The usual suspect.
        if isNetworkError {
            return true
        }

        // The `responseStatusCode` logic may go here.

        // By default, do not retry.
        return false
    }

    private typealias `Self` = HTTPRequestRetrier

}

extension HTTPRequestRetrier: Alamofire.RequestRetrier {

    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        let isNetworkError = E(error) == .networkingError
        let responseStatusCode = request.response?.statusCode
        let shouldRetry = shouldRetryRequest(withRetryCount: Int(request.retryCount), isNetworkError: isNetworkError, responseStatusCode: responseStatusCode)
        if shouldRetry {
            log.debug("Retrying an HTTP request retried \(request.retryCount) times before:\n\(request)", logCategory)
        }
        completion(shouldRetry, Self.retryingRequestsConfig.retryingTimeDelay)
    }

}
