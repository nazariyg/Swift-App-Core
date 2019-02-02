// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public class KeyboardDismissibleView: UIView {

    public var keyboardDismissingEnabled = true

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard keyboardDismissingEnabled else { return }
        endEditing(true)
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
    }

}
