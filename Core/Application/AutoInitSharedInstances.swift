// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import Foundation
import Cornerstones

struct AutoInitSharedInstances {

    static func initializeAll() {
        DispatchQueue.main.executeSync {
            // Shared instances to be initialized at the very start.

            // Core.
            _ = Store.shared
            _ = Network.shared
            _ = AuthService.shared
            _ = UserService.shared
            _ = RemoteNotificationsService.shared
        }
    }

}
