// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public extension Bundle {

    var id: String {
        return bundleIdentifier ?? "unknown.bundle.id"
    }

    static var mainBundleID: String {
        return main.id
    }

}
