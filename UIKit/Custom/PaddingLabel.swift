//
//  PaddingLabel.swift
//
//  Created by Andrei Gubceac.
//

import UIKit

class PaddingLabel: UILabel {
    var inset = UIEdgeInsets.zero
    @IBInspectable public var bottomInset: CGFloat {
        get { return inset.bottom }
        set { inset.bottom = newValue }
    }
    @IBInspectable public var leftInset: CGFloat {
        get { return inset.left }
        set { inset.left = newValue }
    }
    @IBInspectable public var rightInset: CGFloat {
        get { return inset.right }
        set { inset.right = newValue }
    }
    @IBInspectable public var topInset: CGFloat {
        get { return inset.top }
        set { inset.top = newValue }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += (inset.left + inset.right)
        size.height += (inset.top + inset.bottom)
        return size
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.width += (inset.left + inset.right)
        size.height += (inset.top + inset.bottom)
        return size
    }
}
