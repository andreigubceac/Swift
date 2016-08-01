//
//  NSLayoutConstraint.swift
//
//  Created by Andrei Gubceac on 8/1/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    
    func setMultiplier(multiplier:CGFloat) -> NSLayoutConstraint {
        
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
        newConstraint.active = true
        
        NSLayoutConstraint.deactivateConstraints([self])
        NSLayoutConstraint.activateConstraints([newConstraint])
        return newConstraint
    }
}