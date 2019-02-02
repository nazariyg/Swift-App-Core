// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public enum E: Swift.Error, CaseIterable {

    case networkingError

    case serverError
    case notAuthenticated
    case networkResponseNotFound
    case httpErrorCode
    case unexpectedHTTPResponseContentType
    case unexpectedHTTPResponsePayload
    case apiEntityDeserializationError

    // Authentication.
    case userNameAlreadyExists
    case userNameIsInvalid
    case userNameIsTooLong
    case passwordIsInvalid
    case passwordIsTooLong
    case emailIsInvalid
    case emailIsTooLong
    case emailAlreadyExists
    case unknownLoginCredentials

    case unknown

}
