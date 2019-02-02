// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

public extension Backend.API {

    var request: HTTPRequest {
        switch self {

        case .playground:
            return HTTPRequest(
                url: Self.backendType.url[self],
                authentication: .required)

        }
    }

    static let baseAuthentication: HTTPRequestAuthentication = .required

    private typealias `Self` = Backend.API

}
