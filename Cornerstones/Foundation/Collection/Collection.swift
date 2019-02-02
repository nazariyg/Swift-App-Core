// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public extension Collection {

    var isNotEmpty: Bool {
        return !isEmpty
    }

    var lastIndex: Index {
        return index(endIndex, offsetBy: -1)
    }

    subscript(safe index: Index) -> Element? {
        return startIndex <= index && index < endIndex ? self[index] : nil
    }

}

public extension MutableCollection {

    subscript(safe index: Index) -> Element? {
        get {
            return startIndex <= index && index < endIndex ? self[index] : nil
        }
        set(element) {
            if let element = element {
                if startIndex <= index && index < endIndex {
                    self[index] = element
                }
            }
        }
    }

}
