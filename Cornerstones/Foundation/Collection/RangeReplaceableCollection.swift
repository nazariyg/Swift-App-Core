// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation

public extension RangeReplaceableCollection {

    func appending(_ newElement: Element) -> Self {
        var collection = self
        collection.append(newElement)
        return collection
    }

    func appending<S: Sequence>(contentsOf newElements: S) -> Self where Element == S.Element {
        var collection = self
        collection.append(contentsOf: newElements)
        return collection
    }

}
