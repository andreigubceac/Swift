//
//  UIView+Geometry.swift
//  FourSynapses
//
//  Created by Andrei Gubceac on 1/28/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//


import UIKit

extension UIView {
    var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius;
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    var borderColor : UIColor {
        get {
            return UIColor(CGColor: layer.borderColor!);
        }
        set {
            layer.borderColor = newValue.CGColor;
        }
    }
    var borderWidth : CGFloat {
        get {
            return layer.borderWidth;
        }
        set {
            layer.borderWidth = newValue;
        }
    }
    
}

/*Geometry*/
extension UIView {
    
    var left : CGFloat {
        set {
            var frame:CGRect = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var right : CGFloat {
        set {
            var frame:CGRect = self.frame
            frame.origin.x = newValue - frame.size.width
            self.frame = frame
        }
        get {
            return CGRectGetMaxX(self.frame)
        }
    }
    
    var top : CGFloat {
        set {
            var frame:CGRect = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var bottom : CGFloat {
        set {
            var frame:CGRect = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
        get {
            return CGRectGetMaxY(self.frame)
        }
    }
    
    var width : CGFloat {
        set {
            var frame:CGRect = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        get {
            return self.frame.width
        }
    }
    
    var height : CGFloat {
        set {
            var frame:CGRect = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        get {
            return self.frame.height
        }
    }
    
    var size : CGSize {
        set {
            var frame:CGRect = self.frame
            frame.size = newValue
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
}