// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public extension Dictionary where Value: Equatable {

    func allKeys(forValue value: Value) -> [Key] {
        return compactMap { k, v in
            return v == value ? k : nil
        }
    }

    func anyKey(forValue value: Value) -> Key? {
        for (k, v) in self where v == value {
            return k
        }
        return nil
    }

}

public extension Dictionary {

    mutating func mergeReplacing(dictionary: Dictionary) {
        merge(dictionary) { (_, new) in new }
    }

    mutating func mergeKeeping(dictionary: Dictionary) {
        merge(dictionary) { (current, _) in current }
    }

    func mergingWithReplacing(dictionary: Dictionary) -> Dictionary {
        return merging(dictionary) { (_, new) in new }
    }

    func mergingWithKeeping(dictionary: Dictionary) -> Dictionary {
        return merging(dictionary) { (current, _) in current }
    }

}

public extension Dictionary {

    var prettyPrinted: String {
        let prettyPrinted = "\(self as AnyObject)"
        return prettyPrinted
    }

}
