// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

// With `RemoteAPI` and `RemoteAPIEndpoint` protocols you can structure an API as follows:
//
//     public struct Backend: RemoteAPI {
//
//         public static let baseURL = URL(string: "https://domain.com")!  // or from a provider
//
//         public enum API: RemoteAPIEndpoint {
//
//             public static let baseAuthentication: HTTPRequestAuthentication = .notRequired  // override
//
//             case version  // "api/version"
//             // other endpoints
//             // ...
//
//             public enum User: RemoteAPIEndpoint {
//
//                 case create  // "api/user/create"
//                 // other endpoints
//                 // ...
//
//                 public enum Profile: RemoteAPIEndpoint {
//
//                     case getAll               // "api/user/profile/getAll
//                     case get(userID: String)  // "api/user/profile/get/<userID>"
//                     // other endpoints
//                     // ...
//
//                 }
//
//             }
//
//         }
//
//     }
//
// By default, API paths are generated from the names of nested enums and their cases. All path components appear in lowercase snake_case.

// MARK: - Protocol

public protocol RemoteAPI {
    static var baseURL: URL { get }
    static var url: RemoteAPIURLSubscript { get }
}

// MARK: - Implementation

public extension RemoteAPI {

    static var url: RemoteAPIURLSubscript {
        return RemoteAPIURLSubscript(apiType: self)
    }

}

public final class RemoteAPIURLSubscript {

    private let apiType: RemoteAPI.Type

    fileprivate init(apiType: RemoteAPI.Type) {
        self.apiType = apiType
    }

    public subscript(endpoint: RemoteAPIEndpoint) -> URL {
        let endpointPath = endpoint.path
        let url = apiType.baseURL.appendingPathComponent(endpointPath)
        return url
    }

}
