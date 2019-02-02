// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

class UIEmbeddingNavigationController: UINavigationController {

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }

    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    private func commonInit() {
        isNavigationBarHidden = true
    }

}
