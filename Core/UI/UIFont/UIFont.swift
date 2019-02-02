// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones

extension UIFont {

    // MARK: - Main font

    static func main(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: screenify(size))!
    }

    static func mainBold(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: screenify(size))!
    }

    static func mainMedium(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: screenify(size))!
    }

    static func mainLight(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Light", size: screenify(size))!
    }

    static func mainItalic(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Italic", size: screenify(size))!
    }

    static func mainStyle(_ style: UIFont.TextStyle) -> UIFont {
        let size = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style).pointSize
        let font: UIFont
        switch style {
        case .headline:
            font = UIFont(name: "Roboto-Medium", size: size)!
        default:
            font = UIFont(name: "Roboto-Regular", size: size)!
        }
        let scalingFont = UIFontMetrics(forTextStyle: style).scaledFont(for: font)
        return scalingFont
    }

    // MARK: - System font

    static func system(_ size: CGFloat) -> UIFont {
        return systemFont(ofSize: screenify(size))
    }

    static func systemBold(_ size: CGFloat) -> UIFont {
        return boldSystemFont(ofSize: screenify(size))
    }

    static func systemMedium(_ size: CGFloat) -> UIFont {
        return systemWeight(size: size, weight: .medium)
    }

    static func systemLight(_ size: CGFloat) -> UIFont {
        return systemWeight(size: size, weight: .light)
    }

    static func systemItalic(_ size: CGFloat) -> UIFont {
        return italicSystemFont(ofSize: screenify(size))
    }

    static func systemWeight(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return systemFont(ofSize: screenify(size), weight: weight)
    }

    static func systemMonospacedDigit(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return monospacedDigitSystemFont(ofSize: screenify(size), weight: weight)
    }

    static func systemStyle(_ style: UIFont.TextStyle) -> UIFont {
        // `preferredFont` scales the size of the returned font depending on the device model and screen size.
        return preferredFont(forTextStyle: style)
    }

    // MARK: - Font listing

    public static func printAvailableFontNames() {
        familyNames.forEach { fontNames(forFamilyName: $0).forEach { print($0) } }
    }

}
