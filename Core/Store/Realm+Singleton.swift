// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones
import RealmSwift

public extension Realm {

    public subscript<Model: Object>(key: Model.Type) -> Model? {
        get {
            let existingObjects = objects(key)
            assert(existingObjects.count <= 1)
            return existingObjects.first
        }
        set(object) {
            // Relying on the fact that `key` is a singleton itself.
            synchronized(key) {
                if let object = object {
                    // Add or replace.
                    let existingObjects = objects(key)
                    modify {
                        existingObjects.forEach { existingObject in
                            if !existingObject.isSameObject(as: object) {
                                delete(existingObject)
                            }
                        }
                        add(object)
                    }
                } else {
                    // Delete.
                    let existingObjects = objects(key)
                    modify {
                        delete(existingObjects)
                    }
                }
            }
        }
    }

}
