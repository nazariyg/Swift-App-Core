// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public extension String {

    var isNotEmpty: Bool {
        return !isEmpty
    }

    func trimmed() -> String {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed
    }

    func trimmedRemovingAllNewlines() -> String {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let newlineless = trimmed.replacingOccurrences(of: CharacterSet.newlines, with: "")
        return newlineless
    }

    var isAlphanumeric: Bool {
        guard isNotEmpty else { return false }
        let isAlphanumeric = range(of: "\\W", options: .regularExpression) == nil
        return isAlphanumeric
    }

    func contains(substring: String) -> Bool {
        return range(of: substring) != nil
    }

    func containsCaseInsensitive(substring: String) -> Bool {
        return range(of: substring, options: .caseInsensitive) != nil
    }

    func countOccurrences(ofSubstring substring: String) -> Int {
        guard isNotEmpty && substring.isNotEmpty else { return 0 }
        var numOccurrences = 0
        var currentSearchRange: Range<String.Index>?
        while let foundRange = range(of: substring, options: [], range: currentSearchRange) {
            numOccurrences += 1
            currentSearchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return numOccurrences
    }

    func countOccurrences(ofCharacterSet characterSet: CharacterSet) -> Int {
        guard isNotEmpty else { return 0 }
        var numOccurrences = 0
        var currentSearchRange: Range<String.Index>?
        while let foundRange = rangeOfCharacter(from: characterSet, options: [], range: currentSearchRange) {
            numOccurrences += 1
            currentSearchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return numOccurrences
    }

    func snakecased() -> String {
        let snakeCased = replacingOccurrences(of: "([a-z])([A-Z])", with: "$1_$2", options: .regularExpression).lowercased()
        return snakeCased
    }

    func dashcased() -> String {
        let snakeCased = replacingOccurrences(of: "([a-z])([A-Z])", with: "$1-$2", options: .regularExpression).lowercased()
        return snakeCased
    }

    func replacingOccurrences(of target: CharacterSet, with replacement: String) -> String {
        let newString = components(separatedBy: target).joined(separator: replacement)
        return newString
    }

    static func randomID() -> String {
        let randomID = UUID().uuidString
        return randomID
    }

}

public extension String.SubSequence {

    var string: String {
        return String(self)
    }

}
