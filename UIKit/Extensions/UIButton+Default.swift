//
//  UIButton+Default.swift
//
//  Created by Andrei Gubceac on 2/1/16.
//  Copyright © 2016 . All rights reserved.
//

import UIKit

/*Custom UI*/
extension UIButton {
    
    class func buttonWith(_ target : AnyObject?, action : Selector?, image : String) -> UIButton {
        let b = UIButton(type: .custom);
        if action != nil {
            b.addTarget(target, action: action!, for: .touchUpInside)
        }
        b.setBackgroundImage(UIImage(named: image), for: .normal)
        b.frame.size = b.backgroundImage(for: .normal)!.size
        return b
    }

    class func buttonWith(_ target : AnyObject?, action : Selector?, title : String) -> UIButton {
        let b = UIButton(type: .custom);
        if action != nil {
            b.addTarget(target, action: action!, for: .touchUpInside)
        }
        b.setTitle(title, for: .normal)
        b.sizeToFit()
        return b
    }

    class func navigationItem(_ target : AnyObject?, action : Selector?, image : String) -> UIButton {
        let b = self.buttonWith(target, action: action, image: image)
        if let image = b.backgroundImage(for: .normal) {
            b.setBackgroundImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
        return b
    }
        
}

class TopImageBottomTitleButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        titleLabel?.textAlignment = .center
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.titleRect(forContentRect: contentRect)
        return CGRect(x: 0, y: contentRect.height - rect.height, width: contentRect.width, height: rect.height)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let rect = super.imageRect(forContentRect: contentRect)
        let titleRect = self.titleRect(forContentRect: contentRect)
        return CGRect(x: (contentRect.width - rect.width)/2.0, y: (contentRect.height - titleRect.height - rect.height)/2.0,
                      width: rect.width, height: rect.height)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        if let image = imageView?.image {
            var labelHeight: CGFloat = 0.0
            if let size = titleLabel?.sizeThatFits(CGSize(width: contentRect(forBounds: bounds).width, height: CGFloat.greatestFiniteMagnitude)) {
                labelHeight = size.height
            }
            return CGSize(width: size.width, height: image.size.height + labelHeight)
        }
        return size
    }
}
