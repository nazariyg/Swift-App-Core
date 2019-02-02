// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

// MARK: - Protocol

public protocol RemoteAPIEndpoint {
    static var backendType: RemoteAPI.Type { get }
    static var rootEndpointType: RemoteAPIEndpoint.Type { get }
    static var baseAuthentication: HTTPRequestAuthentication { get }
    var url: URL { get }
    var pathComponent: String { get }
}

// MARK: - Implementation

public extension RemoteAPIEndpoint {

    var pathComponent: String {
        switch self {
        default:
            return caseName
        }
    }

    var caseName: String {
        var caseName = String(describing: self)
        if let parenthesisIndex = caseName.firstIndex(of: "(") {
            caseName = String(caseName[..<parenthesisIndex])
        }
        return caseName
    }

    var url: URL {
        return Self.backendType.url[self]
    }

}

// MARK: - Internal

extension RemoteAPIEndpoint {

    var path: String {
        let rootLevelPath = fullStringType(type(of: self).rootEndpointType)
        let thisLevelPath = fullStringType(self)
        let rootLevel =
            rootLevelPath.split(separator: ".")
                .last!
                .string
                .dashcased()
        let thisLevelArray =
            thisLevelPath.split(separator: ".")
                .map { String($0) }
                .appending(pathComponent)
                .map { $0.dashcased() }
        var thisLevel = ""
        if let rootLevelIndex = thisLevelArray.firstIndex(of: rootLevel) {
            thisLevel = thisLevelArray[rootLevelIndex...].joined(separator: "/")
        }
        let path = thisLevel
        return path
    }

}
