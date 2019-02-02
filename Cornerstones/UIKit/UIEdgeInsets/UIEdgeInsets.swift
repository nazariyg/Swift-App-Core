// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public extension UIEdgeInsets {

    init(inset: CGFloat) {
        self.init(top: inset, left: inset, bottom: inset, right: inset)
    }

    init(horizontalInset: CGFloat, verticalInset: CGFloat) {
        self.init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }

    init(horizontalInset: CGFloat) {
        self.init(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
    }

    init(verticalInset: CGFloat) {
        self.init(top: verticalInset, left: 0, bottom: verticalInset, right: 0)
    }

}
