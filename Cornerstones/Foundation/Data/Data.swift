// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public extension Data {

    /// The produced string is in lower case.
    var hexString: String {
        let hexString =
            self
            .map { String(format: "%02hhx", $0) }
            .joined()
        return hexString
    }

    var string: String? {
        let string = String(data: self, encoding: .utf8)
        return string
    }

}
