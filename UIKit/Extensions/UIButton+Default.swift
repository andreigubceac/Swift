//
//  UIButton+Default.swift
//
//  Created by Andrei Gubceac on 2/1/16.
//  Copyright © 2016 . All rights reserved.
//

import UIKit

/*Custom UI*/
extension UIButton {
    
    class func buttonWith(target : AnyObject?, action : Selector?, image : String) -> UIButton {
        let b = UIButton(type: .Custom);
        if action != nil {
            b.addTarget(target, action: action!, forControlEvents: .TouchUpInside)
        }
        b.setBackgroundImage(UIImage(named: image), forState: .Normal)
        b.frame.size = b.backgroundImageForState(.Normal)!.size
        return b
    }

    class func buttonWith(target : AnyObject?, action : Selector?, title : String) -> UIButton {
        let b = UIButton(type: .Custom);
        if action != nil {
            b.addTarget(target, action: action!, forControlEvents: .TouchUpInside)
        }
        b.setTitle(title, forState: .Normal)
        b.sizeToFit()
        return b
    }

    class func navigationItem(target : AnyObject?, action : Selector?, image : String) -> UIButton {
        let b = self.buttonWith(target, action: action, image: image)
        if let image = b.backgroundImageForState(.Normal) {
            b.setBackgroundImage(image.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
        return b
    }
        
}
