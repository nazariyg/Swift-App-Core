// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public struct NewPasswordValidator {

    public struct Rules {

        public let minNumTotalCharacters: Int
        public let minNumLowercaseLetters: Int?
        public let minNumUppercaseLetters: Int?
        public let minNumDigits: Int?

        public init(
            minNumTotalCharacters: Int,
            minNumLowercaseLetters: Int? = nil,
            minNumUppercaseLetters: Int? = nil,
            minNumDigits: Int? = nil) {

            self.minNumTotalCharacters = minNumTotalCharacters
            self.minNumLowercaseLetters = minNumLowercaseLetters
            self.minNumUppercaseLetters = minNumUppercaseLetters
            self.minNumDigits = minNumDigits
        }
    }

    public enum Error: Swift.Error {
        case notEnoughCharacters(minNumCharacters: Int)
        case notEnoughLowercaseLetters(minNumLetters: Int)
        case notEnoughUppercaseLetters(minNumLetters: Int)
        case notEnoughDigits(minNumDigits: Int)
    }

    public let password: String
    public let rules: Rules

    public init(_ password: String, rules: Rules) {
        self.password = password
        self.rules = rules
    }

    public func validate() -> ValidationResult<Error> {
        guard password.count >= rules.minNumTotalCharacters else {
            return .invalid(.notEnoughCharacters(minNumCharacters: rules.minNumTotalCharacters))
        }

        if let minNumLowercaseLetters = rules.minNumLowercaseLetters {
            guard password.countOccurrences(ofCharacterSet: .lowercaseLetters) >= minNumLowercaseLetters else {
                return .invalid(.notEnoughLowercaseLetters(minNumLetters: minNumLowercaseLetters))
            }
        }

        if let minNumUppercaseLetters = rules.minNumUppercaseLetters {
            guard password.countOccurrences(ofCharacterSet: .uppercaseLetters) >= minNumUppercaseLetters else {
                return .invalid(.notEnoughUppercaseLetters(minNumLetters: minNumUppercaseLetters))
            }
        }

        if let minNumDigits = rules.minNumDigits {
            guard password.countOccurrences(ofCharacterSet: .decimalDigits) >= minNumDigits else {
                return .invalid(.notEnoughDigits(minNumDigits: minNumDigits))
            }
        }

        return .valid
    }

}
