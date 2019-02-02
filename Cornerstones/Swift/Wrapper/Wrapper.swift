// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

final class ValueWrapper<Type> {

    let value: Type

    init(_ value: Type) {
        self.value = value
    }

}

final class MutableValueWrapper<Type> {

    var value: Type

    init(_ value: Type) {
        self.value = value
    }

}

final class AnyWrapper {

    let value: Any

    init(_ value: Any) {
        self.value = value
    }

}

final class MutableAnyWrapper {

    var value: Any

    init(_ value: Any) {
        self.value = value
    }

}
