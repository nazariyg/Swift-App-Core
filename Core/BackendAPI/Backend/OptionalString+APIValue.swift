// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public extension Optional {

    var optionalJSONParamValue: Any {
        return self ?? NSNull()
    }

}
