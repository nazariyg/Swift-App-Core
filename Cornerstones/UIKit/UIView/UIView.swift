// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public extension UIView {

    enum SeparatorType {
        case top
        case bottom
    }

    struct SeparatorInsets {
        let left: CGFloat
        let right: CGFloat

        public static let zero = SeparatorInsets(left: 0, right: 0)

        public init(left: CGFloat, right: CGFloat) {
            self.left = left
            self.right = right
        }
    }

    func addSeparator(type: SeparatorType, color: UIColor, insets: SeparatorInsets = .zero, height: CGFloat = 1) {
        let separatorView = UIView(frame: .zero)
        addSubview(separatorView)
        with(separatorView) {
            $0.backgroundColor = color
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: height).isActive = true
            $0.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
            $0.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right).isActive = true
        }
        switch type {
        case .top:
            separatorView.topAnchor.constraint(equalTo: topAnchor)
        default:
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
    }

}
