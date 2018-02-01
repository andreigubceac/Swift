//
//  PaddingLabel.swift
//
//  Created by Andrei Gubceac.
//

import UIKit

class PaddingLabel: UILabel {
    var edges = UIEdgeInsets.zero
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, edges))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += (edges.left + edges.right)
        size.height += (edges.top + edges.bottom)
        return size
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.width += (edges.left + edges.right)
        size.height += (edges.top + edges.bottom)
        return size
    }
}
