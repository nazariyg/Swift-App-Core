// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones

@IBDesignable
public final class UIIconCircleButton: UIButton {

    public static let defaultIconPadding: CGFloat = 8
    public static let defaultFillColor: UIColor? = nil
    public static let defaultLineColor: UIColor? = nil
    public static let defaultLineWidth: CGFloat = 1.5
    public static let defaultDisabledIconTintColor = Config.shared.appearance.defaultDisabledForegroundColor
    public static let defaultDisabledFillColor = Config.shared.appearance.defaultDisabledBackgroundColor
    public static let defaultDisabledLineColor = Config.shared.appearance.defaultDisabledForegroundColor

    @IBInspectable private var iconPadding: CGFloat = defaultIconPadding
    @IBInspectable private var fillColor: UIColor? = defaultFillColor
    @IBInspectable private var lineColor: UIColor? = defaultLineColor
    @IBInspectable private var lineWidth: CGFloat = defaultLineWidth
    @IBInspectable private var disabledIconTintColor: UIColor = Config.shared.appearance.defaultDisabledForegroundColor
    @IBInspectable private var disabledFillColor: UIColor = Config.shared.appearance.defaultDisabledBackgroundColor
    @IBInspectable private var disabledLineColor: UIColor = Config.shared.appearance.defaultDisabledForegroundColor

    private var iconImageView: UIImageView!

    public init(
        iconPadding: CGFloat = defaultIconPadding,
        fillColor: UIColor? = defaultFillColor,
        lineColor: UIColor? = defaultLineColor,
        lineWidth: CGFloat = defaultLineWidth,
        disabledIconTintColor: UIColor = Config.shared.appearance.defaultDisabledForegroundColor,
        disabledFillColor: UIColor = Config.shared.appearance.defaultDisabledBackgroundColor,
        disabledLineColor: UIColor = Config.shared.appearance.defaultDisabledForegroundColor) {

        self.iconPadding = screenify(iconPadding)
        self.fillColor = fillColor
        self.lineColor = lineColor
        self.lineWidth = screenify(lineWidth)
        self.disabledIconTintColor = disabledIconTintColor
        self.disabledFillColor = disabledFillColor
        self.disabledLineColor = disabledLineColor

        super.init(frame: .zero)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        iconPadding = screenify(iconPadding)
        lineWidth = screenify(lineWidth)

        commonInit()
    }

    private func commonInit() {
        iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        with(self, iconImageView!) {
            $0.addSubview($1)
            $1.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $1.leftAnchor.constraint(equalTo: $0.leftAnchor, constant: iconPadding),
                $1.rightAnchor.constraint(equalTo: $0.rightAnchor, constant: -iconPadding),
                $1.topAnchor.constraint(equalTo: $0.topAnchor, constant: iconPadding),
                $1.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -iconPadding)
            ])
        }
    }

    public var icon: UIImage? {
        get {
            return iconImageView.image
        }
        set(icon) {
            iconImageView.image = icon
        }
    }

    public override func layerWillDraw(_ layer: CALayer) {
        super.layerWillDraw(layer)

        if iconImageView.image?.renderingMode == .alwaysTemplate {
            if isEnabled {
                iconImageView.tintColor = Config.shared.appearance.defaultForegroundColor
            } else {
                iconImageView.tintColor = disabledIconTintColor
            }
        }
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let size = bounds.size

        let diameter = min(size.width, size.height)
        let circleRect = CGRect(x: (size.width - diameter)/2, y: (size.height - diameter)/2, width: diameter, height: diameter)

        if let fillColor = fillColor {
            let inset = lineWidth/2
            let fillCircleRect = circleRect.insetBy(dx: inset, dy: inset)
            let color = isEnabled ? fillColor : disabledFillColor
            context.setFillColor(color.cgColor)
            context.fillEllipse(in: fillCircleRect)
        }

        if let lineColor = lineColor {
            let inset = lineWidth/2
            let lineCircleRect = circleRect.insetBy(dx: inset, dy: inset)
            let color = isEnabled ? lineColor : disabledLineColor
            context.setStrokeColor(color.cgColor)
            context.setLineWidth(lineWidth)
            context.strokeEllipse(in: lineCircleRect)
        }
    }

}
