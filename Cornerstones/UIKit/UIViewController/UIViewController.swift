// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public extension UIViewController {

    static var topViewController: UIViewController? {
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            var viewController = rootViewController
            while viewController.presentedViewController != nil {
                viewController = viewController.presentedViewController!
            }
            return viewController
        } else {
            return nil
        }
    }

}
