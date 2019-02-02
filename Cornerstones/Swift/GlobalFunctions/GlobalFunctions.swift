// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

@discardableResult
public func with<Type>(_ subject: Type, _ closure: (Type) -> Void) -> Type {
    closure(subject)
    return subject
}

public func with<Type0, Type1>(_ subject0: Type0, _ subject1: Type1, _ closure: (Type0, Type1) -> Void) {
    closure(subject0, subject1)
}

/// "TypeName"
public func stringType(_ some: Any) -> String {
    let string = (some is Any.Type) ? String(describing: some) : String(describing: type(of: some))
    return string
}

/// "Module.TypeName"
public func fullStringType(_ some: Any) -> String {
    let string = (some is Any.Type) ? String(reflecting: some) : String(reflecting: type(of: some))
    return string
}
