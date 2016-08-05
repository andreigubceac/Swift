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
        b.setBackgroundImage(UIImage(named: image), for: UIControlState())
        b.frame.size = b.backgroundImage(for: UIControlState())!.size
        return b
    }

    class func buttonWith(_ target : AnyObject?, action : Selector?, title : String) -> UIButton {
        let b = UIButton(type: .custom);
        if action != nil {
            b.addTarget(target, action: action!, for: .touchUpInside)
        }
        b.setTitle(title, for: UIControlState())
        b.sizeToFit()
        return b
    }

    class func navigationItem(_ target : AnyObject?, action : Selector?, image : String) -> UIButton {
        let b = self.buttonWith(target, action: action, image: image)
        if let image = b.backgroundImage(for: UIControlState()) {
            b.setBackgroundImage(image.withRenderingMode(.alwaysTemplate), for: UIControlState())
        }
        return b
    }
        
}
