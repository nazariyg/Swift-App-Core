// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import RealmSwift

@objcMembers
public final class User: Object {

    public dynamic var userID = String()
    public dynamic var name = String()
    public dynamic var email: String?

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
    }

}
