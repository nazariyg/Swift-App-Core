// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

public extension Backend.API.Push {

    var request: HTTPRequest {

        switch self {

        case let .registerApnsDevice(
            deviceToken,
            deviceID):

            return HTTPRequest(
                url: url,
                authentication: .required,
                method: .post,
                parameters: HTTPRequestParameters([
                    "device_token": deviceToken,
                    "device_id": deviceID
                ], placement: .body(encoding: .json)))

        case let .unregisterApnsDevice(deviceID):
            return HTTPRequest(
                url: url,
                authentication: .notRequired,
                method: .post,
                parameters: HTTPRequestParameters([
                    "device_id": deviceID
                ], placement: .body(encoding: .json)))

        }

    }

    static let baseAuthentication: HTTPRequestAuthentication = .required

}
