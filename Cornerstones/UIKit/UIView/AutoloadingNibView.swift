// Copyright © 2018 Nazariy Gorpynyuk.
// All rights reserved.

import UIKit

public class AutoloadingNibView: UIView {

    private var contentView: UIView!
    private var contentViewIsLoaded = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        loadContentViewIfNeeded()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadContentViewIfNeeded()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        loadContentViewIfNeeded()
    }

    public override func layoutSubviews() {
        loadContentViewIfNeeded()
        super.layoutSubviews()
        contentView.frame = bounds
    }

    private func loadContentViewIfNeeded() {
        guard !contentViewIsLoaded else { return }

        backgroundColor = .clear
        isOpaque = false

        let nibName = stringType(self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        contentView = nib.instantiate(withOwner: self).first as? UIView
        contentView.frame = bounds
        contentView.backgroundColor = .clear
        contentView.isOpaque = false
        addSubview(contentView)

        contentViewIsLoaded = true
    }

}
