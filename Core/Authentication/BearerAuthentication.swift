// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

private let logCategory = "Bearer Auth"

/// Bearer authentication to be used with the backend API.
final class BearerAuthentication: AuthenticationScheme {

    /// Skipping repeats.
    private let _isAuthenticated: Mp<Bool>
    var isAuthenticated: Pr<Bool> {
        return _isAuthenticated.skipRepeats()
    }

    var authenticationStateToken: String? {
        return authenticationToken?.token
    }

    private var authenticationToken = BearerAuthenticationToken()

    private static let authenticationTokenResponseHeaderName = "X-Bearer-Authentication-Token"

    init() {
        _isAuthenticated = Mp<Bool>(authenticationToken != nil)
        if _isAuthenticated.value {
            log.debug("Found an authentication token", logCategory)
        }
        registerWithAPIRequestPluginProvider()
    }

    func unauthenticate() {
        synchronized(self) {
            if let authenticationToken = authenticationToken {
                log.debug("Clearing the authentication token", logCategory)
                authenticationToken.clearToken()
                self.authenticationToken = nil
            }
            _isAuthenticated.value = false
        }
    }

    private typealias `Self` = BearerAuthentication

    private func registerWithAPIRequestPluginProvider() {
        BackendAPIRequestPluginProvider.shared.addHTTPRequestMapper(self)
        BackendAPIRequestPluginProvider.shared.addHTTPDataResponseObserver(self)
        BackendAPIRequestPluginProvider.shared.addHTTPResponseErrorObserver(self)
    }

}

extension BearerAuthentication: BackendAPIRequestPluginHTTPRequestMapper {

    func mapHTTPRequest(_ request: HTTPRequest) -> HTTPRequest {
        return synchronized(self) {
            guard
                request.authentication == .required,
                let authenticationToken = authenticationToken
            else { return request }

            // Attach the authentication token to the request.
            log.verbose("Attaching the authentication token to a request: \(request.safeDescription)", logCategory)
            let authHeaders: [HTTPHeader.Request: String] = [
                .authorization: "Bearer \(authenticationToken.token)"
            ]

            var resultRequest = request
            resultRequest.includeHeaders(authHeaders)
            return resultRequest
        }
    }

}

extension BearerAuthentication: BackendAPIRequestPluginHTTPDataResponseObserver {

    func onHTTPResponse(_ response: HTTPDataResponse) {
        synchronized(self) {
            // Look for an assigned authentication token in the response.
            let headers =
                Dictionary(uniqueKeysWithValues:
                    response.urlResponse.allHeaderFields.compactMap { key, value -> (String, String)? in
                        guard let key = key as? String else { return nil }
                        guard let value = value as? String else { return nil }
                        return (key.lowercased(), value)
                    })
            if let token = headers[Self.authenticationTokenResponseHeaderName.lowercased()] {
                // Received an authentication token.
                log.debug("Received an authentication token for a request: \(response.request.safeDescription)", logCategory)
                authenticationToken = BearerAuthenticationToken(token: token)
                _isAuthenticated.value = true
            }
        }
    }

}

extension BearerAuthentication: BackendAPIRequestPluginHTTPResponseErrorObserver {

    func onHTTPResponseError(_ error: E, request: HTTPRequest) {
        synchronized(self) {
            if error == .notAuthenticated {
                // Received a 401 status code from the backend API.
                guard let authenticationToken = authenticationToken else { return }
                let requestTokenIsSameAsCurrentToken = request.headers[.authorization].map { $0.contains(substring: authenticationToken.token) } ?? false
                if requestTokenIsSameAsCurrentToken {
                    // Not authenticated for the current token that was sent with the request. The current token is of no use.
                    log.debug(
                        "Received a \"not authenticated\" response for the current authentication token that was sent with the request." +
                        " Clearing the current authentication token.",
                        logCategory)
                    ActivityTracker.shared.userDidLogOutUnexpectedly()
                    authenticationToken.clearToken()
                    self.authenticationToken = nil
                    _isAuthenticated.value = false
                }
            }
        }
    }

}
