// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit
import Cornerstones

public final class UIStyledLabel: UILabel {

    public init() {
        super.init(frame: .zero)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        font = .main(UIFont.labelFontSize)
        textColor = Config.shared.appearance.defaultForegroundColor
    }

}
