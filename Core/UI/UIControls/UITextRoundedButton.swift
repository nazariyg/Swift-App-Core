// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones

@IBDesignable
public final class UITextRoundedButton: UIButton {

    public static let defaultHorizontalPadding: CGFloat = 10
    public static let defaultVerticalPadding: CGFloat = 8
    public static let defaultCornerRadius: CGFloat = 10
    public static let defaultLineWidth: CGFloat = 1.5

    @IBInspectable private var horizontalPadding: CGFloat = defaultHorizontalPadding
    @IBInspectable private var verticalPadding: CGFloat = defaultVerticalPadding
    @IBInspectable private var cornerRadius: CGFloat = defaultCornerRadius
    @IBInspectable private var lineWidth: CGFloat = defaultLineWidth
    @IBInspectable private var lineColor: UIColor = Config.shared.appearance.defaultForegroundColor

    public init(
        horizontalPadding: CGFloat = defaultHorizontalPadding,
        verticalPadding: CGFloat = defaultVerticalPadding,
        cornerRadius: CGFloat = defaultCornerRadius,
        lineWidth: CGFloat = defaultLineWidth,
        lineColor: UIColor = Config.shared.appearance.defaultForegroundColor) {

        self.horizontalPadding = screenify(horizontalPadding)
        self.verticalPadding = screenify(verticalPadding)
        self.cornerRadius = screenify(cornerRadius)
        self.lineWidth = screenify(lineWidth)
        self.lineColor = lineColor

        super.init(frame: .zero)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        horizontalPadding = screenify(horizontalPadding)
        verticalPadding = screenify(verticalPadding)
        cornerRadius = screenify(cornerRadius)
        lineWidth = screenify(lineWidth)

        commonInit()
    }

    private func commonInit() {
        titleLabel?.font = .main(UIFont.buttonFontSize)
        setTitleColor(Config.shared.appearance.defaultForegroundColor, for: .normal)
        setTitleColor(Config.shared.appearance.defaultDisabledForegroundColor, for: .disabled)

        contentEdgeInsets = UIEdgeInsets(horizontalInset: horizontalPadding, verticalInset: verticalPadding)

        roundCorners(radius: cornerRadius)
        layer.borderWidth = lineWidth
    }

    public override func draw(_ rect: CGRect) {
        if isEnabled {
            borderUIColor = lineColor
        } else {
            borderUIColor = Config.shared.appearance.defaultDisabledForegroundColor
        }
    }

}
