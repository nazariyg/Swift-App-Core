// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import RealmSwift

public extension Realm {

    public subscript<Model: Object>(key: Model.Type) -> Model? {
        get {
            return objects(key).first
        }
        set(object) {
            if let object = object {
                if let existingObject = objects(Model.self).first {
                    if !object.isSameObject(as: existingObject) {
                        // The two objects are distinct. Replace.
                        modify {
                            delete(existingObject)
                            add(object)
                        }
                    }
                } else {
                    // Add.
                    modify {
                        add(object)
                    }
                }
            } else {
                // Delete if exists.
                if let existingObject = objects(Model.self).first {
                    modify {
                        delete(existingObject)
                    }
                }
            }
        }
    }

}
