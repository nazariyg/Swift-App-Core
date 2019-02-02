// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public struct ExtendedBackgroundExecution {

    public static func begin() -> UIBackgroundTaskIdentifier {
        var backgroundTask = UIBackgroundTaskIdentifier.invalid
        backgroundTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            if backgroundTask != .invalid {
                ExtendedBackgroundExecution.end(backgroundTask)
            }
        })
        return backgroundTask
    }

    public static func end(_ backgroundTask: UIBackgroundTaskIdentifier) {
        if backgroundTask != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTask)
        }
    }

}
