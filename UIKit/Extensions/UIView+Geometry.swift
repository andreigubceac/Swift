//
//  UIView+Geometry.swift
//  FourSynapses
//
//  Created by Andrei Gubceac on 1/28/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//


import UIKit

extension UIView {
    @IBInspectable
    var cornerRadius : CGFloat {
        get {
            return layer.cornerRadius;
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable
    var borderColor : UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!);
        }
        set {
            layer.borderColor = newValue.cgColor;
        }
    }
    @IBInspectable
    var borderWidth : CGFloat {
        get {
            return layer.borderWidth;
        }
        set {
            layer.borderWidth = newValue;
            layer.masksToBounds = true
        }
    }

    var fullRounded : Bool {
        get {
            return self.cornerRadius == self.width / 2
        }
        set {
            self.cornerRadius = newValue ? self.width / 2 : 0
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
            return self.frame.maxX
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
            return self.frame.maxY
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

extension UIView {
    func snapshotView() -> UIView? {
        guard let image = snapshotImage() else { return nil }
        return UIImageView(image: image)
    }
    
    func snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, contentScaleFactor)
        defer { UIGraphicsEndImageContext() }
        
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIView {
    func hide(duration: TimeInterval = 0.15, animations:(()->Void)? = nil, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
            animations?()
        }, completion: completion)
    }

    func show(duration: TimeInterval = 0.15, animations:(()->Void)? = nil, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
            animations?()
        }, completion: completion)
    }
}
