// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones

extension UIView: StoredProperties {

    var baseViewController: UIViewControllerBase? {
        if let baseVC = sp.any[#function] as? UIViewControllerBase {
            return baseVC
        }

        var baseVC: UIViewControllerBase?
        var currentResponder: UIResponder = self
        while true {
            guard let nextResponder = currentResponder.next else { break }
            guard !(nextResponder is UIWindow) else { break }
            if let vc = nextResponder as? UIViewControllerBase {
                baseVC = vc
                break
            }
            currentResponder = nextResponder
        }
        if let baseVC = baseVC {
            sp.any[#function] = baseVC
        }
        return baseVC
    }

}
