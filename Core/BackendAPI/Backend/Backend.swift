// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

// MARK: - Configuration

public extension Backend {
    static var baseURL: URL { return Config.shared.backend.baseURL }
}

public extension RemoteAPIEndpoint {
    static var backendType: RemoteAPI.Type { return Backend.self }
    static var rootEndpointType: RemoteAPIEndpoint.Type { return Backend.API.self }
}

// MARK: - Endpoints

public struct Backend: RemoteAPI {

    // API
    public enum API: RemoteAPIEndpoint {

        // Auth
        public enum Auth: RemoteAPIEndpoint {

            case checkNewUserName(name: String)

            case createUser(
                name: String,
                password: String,
                email: String?,
                measurementSystem: MeasurementSystem,
                alterUserIDs: [String])

            case logIn(
                name: String,
                password: String,
                alterUserIDs: [String])

            case checkLoggedIn

            case logOut

            case changePassword(newPassword: String)

            case resetPassword(email: String)

        }

        // Push
        public enum Push: RemoteAPIEndpoint {

            case registerApnsDevice(
                deviceToken: String,
                deviceID: String)

            case unregisterApnsDevice(deviceID: String)

        }

        case playground

    }

}
