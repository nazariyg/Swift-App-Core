// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones

@IBDesignable
public final class UIRoundedTextField: UITextFieldBase {

    public static let overridingDefaultHorizontalPadding: CGFloat = 16
    public static let defaultBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.15)
    public static let defaultBackgroundCornerRadius: CGFloat = 8

    @IBInspectable private var backgroundCornerRadius: CGFloat = defaultBackgroundCornerRadius

    public init(
        horizontalPadding: CGFloat = overridingDefaultHorizontalPadding,
        verticalPadding: CGFloat = defaultVerticalPadding,
        backgroundColor: UIColor = defaultBackgroundColor,
        backgroundCornerRadius: CGFloat = defaultBackgroundCornerRadius) {

        super.init(horizontalPadding: horizontalPadding, verticalPadding: verticalPadding)

        self.backgroundColor = backgroundColor
        self.backgroundCornerRadius = screenify(backgroundCornerRadius)

        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        backgroundCornerRadius = screenify(backgroundCornerRadius)

        commonInit()
    }

    private func commonInit() {
        roundCorners(radius: backgroundCornerRadius)
    }

}
