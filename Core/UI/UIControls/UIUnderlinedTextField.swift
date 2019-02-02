// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones

@IBDesignable
public final class UIUnderlinedTextField: UITextFieldBase {

    public static let overridingDefaultHorizontalPadding: CGFloat = 4
    public static let defaultUnderlineColor: UIColor = Config.shared.appearance.defaultForegroundColor
    public static let defaultUnderlineWidth: CGFloat = 4

    @IBInspectable private var underlineColor: UIColor = defaultUnderlineColor
    @IBInspectable private var underlineWidth: CGFloat = defaultUnderlineWidth

    public init(
        horizontalPadding: CGFloat = overridingDefaultHorizontalPadding,
        verticalPadding: CGFloat = defaultVerticalPadding,
        underlineColor: UIColor = defaultUnderlineColor,
        underlineWidth: CGFloat = defaultUnderlineWidth) {

        super.init(horizontalPadding: horizontalPadding, verticalPadding: verticalPadding)

        self.underlineColor = underlineColor
        self.underlineWidth = screenify(underlineWidth)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        underlineWidth = screenify(underlineWidth)
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let size = bounds.size

        let color: UIColor
        if !isFirstResponder {
            color = underlineColor.withAlphaComponent(0.5)
        } else {
            color = underlineColor
        }

        let rect = CGRect(x: 0, y: size.height - underlineWidth, width: size.width, height: underlineWidth)

        context.setFillColor(color.cgColor)
        context.fill(rect)
    }

    public override func becomeFirstResponder() -> Bool {
        setNeedsDisplay()
        return super.becomeFirstResponder()
    }

    public override func resignFirstResponder() -> Bool {
        setNeedsDisplay()
        return super.resignFirstResponder()
    }

}
