// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Result

public extension E {

    // MARK: - Lifecycle

    /// Constructs an error from an ID, e.g. sent by the backend.
    init(errorID: String) {
        let flatErrorID =
            errorID
                .replacingOccurrences(of: "_", with: "")  // remove underscores, if any
                .replacingOccurrences(of: ".", with: "")  // remove dots, if any
                .lowercased()  // make lowercased

        let foundError = Self.allCases.first { error -> Bool in
            let caseName = String(describing: error)
            return caseName.lowercased() == flatErrorID
        }

        if foundError == nil {
            assertionFailure("Unknown error ID")
            log.error("Unknown error ID: \(errorID)", nil)
        }
        assert(foundError != nil, "Unknown error ID")

        self = foundError ?? .unknown
    }

    /// Constructs an error from a generic error.
    init(_ error: Swift.Error) {
        if let e = error as? E {
            self = e
            return
        }

        let urlErrors = Self.allUnderlyingNSErrors(withDomain: NSURLErrorDomain, startingWithError: error)
        let isRootedInNetworkError = urlErrors.contains { urlError -> Bool in
            switch urlError.code {
            case NSURLErrorCannotConnectToHost,
                 NSURLErrorCannotFindHost,
                 NSURLErrorDNSLookupFailed,
                 NSURLErrorNetworkConnectionLost,
                 NSURLErrorNotConnectedToInternet,
                 NSURLErrorTimedOut:

                // This is a networking error.
                return true
            default:
                return false
            }
        }

        self = isRootedInNetworkError ? .networkingError : .unknown
    }

    // MARK: - Error message

    var description: String {
        return localizationID.localizedForEnglish
    }

    /// Returns the localized string for the localization identifier formatted as "error_<casename>".
    var localizedDescription: String {
        return localizationID.localized
    }

    // MARK: - Private

    private typealias `Self` = E

    private var localizationID: String {
        let caseName = String(describing: self)
        let localizationID = "error_\(caseName)"
        return localizationID
    }

    private static func allUnderlyingNSErrors(withDomain domain: String, startingWithError error: Error) -> [NSError] {
        var nsErrors: [NSError] = []
        var currentError = error
        while true {
            let nsError = currentError as NSError
            if nsError.domain == domain {
                nsErrors.append(nsError)
            }
            if let underlyingError = nsError.userInfo[NSUnderlyingErrorKey] as? Error {
                currentError = underlyingError
            } else {
                break
            }
        }
        return nsErrors
    }

}

extension E: LocalizedError {

    public var errorDescription: String? {
        return localizedDescription
    }

}

extension E: ErrorConvertible {

    public static func error(from error: Swift.Error) -> E {
        return E(error)
    }

}
