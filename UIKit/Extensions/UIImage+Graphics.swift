//
//  UIImage+Graphics.swift
//
//  Created by Andrei Gubceac on 2/4/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

extension UIImage {
    class func image(_ color : UIColor = UIColor.clear, size : CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        UIGraphicsBeginImageContext(size)
        UIGraphicsGetCurrentContext()?.setFillColor((color.cgColor))
        UIGraphicsGetCurrentContext()?.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
