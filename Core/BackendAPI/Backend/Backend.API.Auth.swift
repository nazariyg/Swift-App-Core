// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

public extension Backend.API.Auth {

    var request: HTTPRequest {

        switch self {

        case let .checkNewUserName(name):
            return HTTPRequest(
                url: url,
                authentication: .notRequired,
                parameters: HTTPRequestParameters([
                    "name": name
                ]))

        case let .createUser(
            name,
            password,
            email,
            measurementSystem,
            alterUserIDs):

            return HTTPRequest(
                url: url,
                authentication: .notRequired,
                method: .post,
                parameters: HTTPRequestParameters([
                    "name": name,
                    "password": password,
                    "email": email.optionalJSONParamValue
                ], placement: .body(encoding: .json)),
                hasSensitiveData: true)

        case let .logIn(
            name,
            password,
            alterUserIDs):

            return HTTPRequest(
                url: url,
                authentication: .notRequired,
                method: .post,
                parameters: HTTPRequestParameters([
                    "name": name,
                    "password": password
                ], placement: .body(encoding: .json)),
                hasSensitiveData: true)

        case .checkLoggedIn:
            return HTTPRequest(
                url: url,
                authentication: .required)

        case .logOut:
            return HTTPRequest(
                url: url,
                authentication: .required,
                method: .post)

        case let .changePassword(newPassword):
            return HTTPRequest(
                url: url,
                authentication: .required,
                method: .post,
                parameters: HTTPRequestParameters([
                    "new_password": newPassword
                ], placement: .body(encoding: .json)),
                hasSensitiveData: true)

        case let .resetPassword(email):
            return HTTPRequest(
                url: url,
                authentication: .notRequired,
                method: .post,
                parameters: HTTPRequestParameters([
                    "email": email
                ], placement: .body(encoding: .json)))

        }

    }

    static let baseAuthentication: HTTPRequestAuthentication = .notRequired

}
