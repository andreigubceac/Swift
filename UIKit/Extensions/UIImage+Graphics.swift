//
//  UIImage+Graphics.swift
//
//  Created by Andrei Gubceac on 2/4/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

extension UIImage {
    class func image(color : UIColor? = UIColor.clearColor(), size : CGSize? = CGSizeMake(1, 1)) -> UIImage {
        UIGraphicsBeginImageContext(size!)
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color?.CGColor)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
