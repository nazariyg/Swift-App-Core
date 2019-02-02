// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public protocol Validator {

    associatedtype Input
    associatedtype ErrorType

    init(_: Input)
    func validate() -> ValidationResult<ErrorType>

}

public enum ValidationResult<ErrorType> {
    case valid
    case invalid(ErrorType)
}
