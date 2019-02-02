// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public extension String {

    /// The produced hash is in lower case.
    var md5: String {
        let data = self.data(using: .utf8)!
        let hashData = data.md5
        let hashString = hashData.hexString
        return hashString
    }

    /// The produced hash is in lower case.
    var sha256: String {
        let data = self.data(using: .utf8)!
        let hashData = data.sha256
        let hashString = hashData.hexString
        return hashString
    }

}
