// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Result

public extension Result {

    var isSuccess: Bool {
        if case .success = self {
            return true
        } else {
            return false
        }
    }

}
