// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public extension UILabel {

    var kerning: Double {
        get {
            guard let kernValue = attributedText?.attribute(.kern, at: 0, effectiveRange: nil) as? NSNumber else { return 0.0 }
            return kernValue.doubleValue
        }
        set {
            var attrText: NSMutableAttributedString
            if let attributedText = attributedText {
                attrText = NSMutableAttributedString(attributedString: attributedText)
            } else if let text = text {
                attrText = NSMutableAttributedString(string: text)
            } else {
                attrText = NSMutableAttributedString(string: "")
            }
            attrText.addAttribute(.kern, value: NSNumber(value: newValue), range: NSRange(location: 0, length: attrText.length))
            attributedText = attrText
        }
    }

}
