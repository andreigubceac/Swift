//
//  UIBarButtonItem+Extension.swift
//  UP Agenda
//
//  Created by Andrei Gubceac on 7/22/17.
//  Copyright © 2017 Omnisource Technologies. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func fixedItem(with width: CGFloat = 15) -> UIBarButtonItem {
        let b = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        b.width = width
        return b
    }
}
