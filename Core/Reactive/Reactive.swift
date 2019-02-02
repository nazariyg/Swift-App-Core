// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import ReactiveSwift
import Result
import ReactiveCocoa

public extension Reactive where Base: NSObject {

    func producer<Value>(forKeyPath keyPath: String) -> Sp<Value?> {
        return producer(forKeyPath: keyPath).map { $0 as? Value }
    }

}
