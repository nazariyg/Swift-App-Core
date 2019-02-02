// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones

@IBDesignable
public class UITextFieldBase: UITextField {

    public static let defaultHorizontalPadding: CGFloat = 0
    public static let defaultVerticalPadding: CGFloat = 0

    @IBInspectable public var clearButtonTintColor: UIColor?

    @IBInspectable private var horizontalPadding: CGFloat = defaultHorizontalPadding
    @IBInspectable private var verticalPadding: CGFloat = defaultVerticalPadding

    private static let sideImagePadding: CGFloat = 2
    private static let sideLabelPadding: CGFloat = 8
    private static let sideLabelFontSizeRatio: CGFloat = 0.8

    public init(
        horizontalPadding: CGFloat = defaultHorizontalPadding,
        verticalPadding: CGFloat = defaultVerticalPadding) {

        self.horizontalPadding = screenify(horizontalPadding)
        self.verticalPadding = screenify(verticalPadding)

        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        horizontalPadding = screenify(horizontalPadding)
        verticalPadding = screenify(verticalPadding)

        commonInit()
    }

    private func commonInit() {
        font = .main(UIFont.labelFontSize)
        textColor = Config.shared.appearance.defaultForegroundColor
        tintColor = Config.shared.appearance.defaultForegroundColor

        autocorrectionType = .no
    }

    public override var placeholder: String? {
        didSet {
            if let placeholder = placeholder {
                attributedPlaceholder =
                    NSAttributedString(
                        string: placeholder,
                        attributes: [
                            .font: UIFont.main(UIFont.labelFontSize),
                            .foregroundColor: Config.shared.appearance.defaultDisabledBackgroundColor
                        ])
            }
        }
    }

    var leftPaddingImage: UIImage? {
        didSet {
            guard let leftPaddingImage = leftPaddingImage else {
                leftView = nil
                leftViewMode = .never
                return
            }

            let imageHorizontalPadding: CGFloat = screenify(Self.sideImagePadding)

            let imageSize = leftPaddingImage.size

            let containerFrame = CGRect(origin: .zero, size: CGSize(width: imageSize.width + 2*imageHorizontalPadding, height: imageSize.height))
            let containerView = UIView(frame: containerFrame)

            let imageViewFrame = CGRect(origin: CGPoint(x: imageHorizontalPadding, y: 0), size: imageSize)
            let imageView = UIImageView(frame: imageViewFrame)
            imageView.contentMode = .scaleAspectFit
            imageView.image = leftPaddingImage
            imageView.tintColor = Config.shared.appearance.defaultForegroundColor
            containerView.addSubview(imageView)

            leftView = containerView
            leftViewMode = .always
        }
    }

    var rightPaddingImage: UIImage? {
        didSet {
            guard let rightPaddingImage = rightPaddingImage else {
                rightView = nil
                rightViewMode = .never
                return
            }

            let imageHorizontalPadding = screenify(Self.sideImagePadding)

            let imageSize = rightPaddingImage.size

            let containerFrame = CGRect(origin: .zero, size: CGSize(width: imageSize.width + 2*imageHorizontalPadding, height: imageSize.height))
            let containerView = UIView(frame: containerFrame)

            let imageViewFrame = CGRect(origin: CGPoint(x: imageHorizontalPadding, y: 0), size: imageSize)
            let imageView = UIImageView(frame: imageViewFrame)
            imageView.contentMode = .scaleAspectFit
            imageView.image = rightPaddingImage
            imageView.tintColor = Config.shared.appearance.defaultForegroundColor
            containerView.addSubview(imageView)

            rightView = containerView
            rightViewMode = .always
        }
    }

    var leftPaddingText: String? {
        didSet {
            guard let leftPaddingText = leftPaddingText else {
                leftView = nil
                leftViewMode = .never
                return
            }

            let label = UILabel()
            label.font = .main(UIFont.labelFontSize*Self.sideLabelFontSizeRatio)
            label.textColor = Config.shared.appearance.defaultForegroundColor
            label.text = leftPaddingText
            label.sizeToFit()

            let labelHorizontalPadding = screenify(Self.sideLabelPadding)

            let containerFrame = CGRect(origin: .zero, size: CGSize(width: label.frame.width + 2*labelHorizontalPadding, height: label.frame.height))
            let containerView = UIView(frame: containerFrame)
            label.frame.origin.x = labelHorizontalPadding
            containerView.addSubview(label)

            leftView = containerView
            leftViewMode = .always
        }
    }

    var leftPaddingLabel: UILabel? {
        didSet {
            guard let leftPaddingLabel = leftPaddingLabel else {
                leftView = nil
                leftViewMode = .never
                return
            }

            let labelHorizontalPadding = screenify(Self.sideLabelPadding)

            let containerFrame =
                CGRect(origin: .zero, size: CGSize(width: leftPaddingLabel.frame.width + 2*labelHorizontalPadding, height: leftPaddingLabel.frame.height))
            let containerView = UIView(frame: containerFrame)
            leftPaddingLabel.frame.origin.x = labelHorizontalPadding
            containerView.addSubview(leftPaddingLabel)

            leftView = containerView
            leftViewMode = .always
        }
    }

    var rightPaddingText: String? {
        didSet {
            guard let rightPaddingText = rightPaddingText else {
                rightView = nil
                rightViewMode = .never
                return
            }

            let label = UILabel()
            label.font = .main(UIFont.labelFontSize*Self.sideLabelFontSizeRatio)
            label.textColor = Config.shared.appearance.defaultForegroundColor
            label.text = rightPaddingText
            label.sizeToFit()

            let labelHorizontalPadding = screenify(Self.sideLabelPadding)

            let containerFrame = CGRect(origin: .zero, size: CGSize(width: label.frame.width + 2*labelHorizontalPadding, height: label.frame.height))
            let containerView = UIView(frame: containerFrame)
            label.frame.origin.x = labelHorizontalPadding
            containerView.addSubview(label)

            rightView = containerView
            rightViewMode = .always
        }
    }

    var rightPaddingLabel: UILabel? {
        didSet {
            guard let rightPaddingLabel = rightPaddingLabel else {
                rightView = nil
                rightViewMode = .never
                return
            }

            let labelHorizontalPadding = screenify(Self.sideLabelPadding)

            let containerFrame =
                CGRect(origin: .zero, size: CGSize(width: rightPaddingLabel.frame.width + 2*labelHorizontalPadding, height: rightPaddingLabel.frame.height))
            let containerView = UIView(frame: containerFrame)
            rightPaddingLabel.frame.origin.x = labelHorizontalPadding
            containerView.addSubview(rightPaddingLabel)

            rightView = containerView
            rightViewMode = .always
        }
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let leftPadding = leftView?.frame.width ?? horizontalPadding
        let rightPadding = rightView?.frame.width ?? horizontalPadding
        return bounds.inset(by: UIEdgeInsets(top: verticalPadding, left: leftPadding, bottom: verticalPadding, right: rightPadding))
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()

        if keyboardAppearance == .default, let baseKeyboardAppearance = baseKeyboardAppearance {
            keyboardAppearance = baseKeyboardAppearance
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if let clearButtonTintColor = clearButtonTintColor {
            for view in subviews {
                if let button = view as? UIButton {
                    if let templateImage = button.image(for: .normal)?.withRenderingMode(.alwaysTemplate) {
                        button.setImage(templateImage, for: .normal)
                        button.setImage(templateImage, for: .highlighted)
                        button.tintColor = clearButtonTintColor
                        break
                    }
                }
            }
        }
    }

    private var baseKeyboardAppearance: UIKeyboardAppearance? {
        return baseViewController?.keyboardAppearance
    }

    private typealias `Self` = UITextFieldBase

}
