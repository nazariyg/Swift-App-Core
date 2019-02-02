// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import RealmSwift

@objcMembers
public final class User: Object {

    public dynamic var userID = String()
    public dynamic var name = String()
    public dynamic var email: String?

    public dynamic var _measurementSystem = String()
    public var measurementSystem: MeasurementSystem {
        get {
            return MeasurementSystem(rawValue: _measurementSystem)!
        }
        set(value) {
            _measurementSystem = value.rawValue
        }
    }

    public override static func primaryKey() -> String? {
        return #keyPath(userID)
    }

}

public extension User {

    convenience init(_ apiUser: APIUser) {
        self.init()

        self.userID = apiUser.userID
        self.name = apiUser.name
        self.email = apiUser.hasEmail ? apiUser.email : nil
        self._measurementSystem = apiUser.measurementSystem
    }

}
