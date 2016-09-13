//
//  NSLayoutConstraint.swift
//
//  Created by Andrei Gubceac on 8/1/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    func setMultiplier(_ multiplier:CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        newConstraint.isActive = true
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
