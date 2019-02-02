// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public struct UI {

    public static func initUI(initialScene: UIScene) -> UIWindow {
        return DispatchQueue.main.executeSync {
            let screenSize = UIScreen.main.bounds.size
            let window = UIWindow(frame: CGRect(origin: .zero, size: screenSize))

            UIScener.shared.initialize(initialScene: initialScene)
            window.rootViewController = UIRootViewControllerContainer.shared as? UIViewController

            let backgroundColor = Config.shared.appearance.defaultBackgroundColor
            window.backgroundColor = backgroundColor
            UIRootViewControllerContainer.shared.view.backgroundColor = backgroundColor

            window.makeKeyAndVisible()
            return window
        }
    }

    static func setGlobalBackgroundColor(_ color: UIColor) {
        DispatchQueue.main.executeSync {
            UIApplication.shared.keyWindow?.backgroundColor = color
            UIRootViewControllerContainer.shared.view.backgroundColor = color
        }
    }

    static func resetGlobalBackgroundColor() {
        DispatchQueue.main.executeSync {
            let backgroundColor = Config.shared.appearance.defaultBackgroundColor
            UIApplication.shared.keyWindow?.backgroundColor = backgroundColor
            UIRootViewControllerContainer.shared.view.backgroundColor = backgroundColor
        }
    }

}
