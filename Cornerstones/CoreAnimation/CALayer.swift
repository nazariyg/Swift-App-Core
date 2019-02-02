// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public extension CALayer {

    var borderUIColor: UIColor? {
        get {
            return borderColor.map { UIColor(cgColor: $0) }
        }
        set(color) {
            borderColor = color?.cgColor
        }
    }

    var backgroundUIColor: UIColor? {
        get {
            return backgroundColor.map { UIColor(cgColor: $0) }
        }
        set(color) {
            backgroundColor = color?.cgColor
        }
    }

    func setShadow(ofSize size: CGFloat, opacity: CGFloat) {
        shadowColor = UIColor.black.cgColor
        shadowOffset = .zero
        shadowRadius = size
        shadowOpacity = Float(opacity)
    }

    func roundCorners(radius: CGFloat) {
        cornerRadius = radius
        masksToBounds = true
    }

    func sharpenCorners() {
        cornerRadius = 0
        masksToBounds = false
    }

}

public extension UIView {

    var borderUIColor: UIColor? {
        get {
            return layer.borderUIColor
        }
        set(color) {
            layer.borderUIColor = color
        }
    }

    func setShadow(ofSize size: CGFloat, opacity: CGFloat) {
        layer.setShadow(ofSize: size, opacity: opacity)
    }

    func roundCorners(radius: CGFloat) {
        layer.roundCorners(radius: radius)
    }

    func sharpenCorners() {
        layer.sharpenCorners()
    }

}
