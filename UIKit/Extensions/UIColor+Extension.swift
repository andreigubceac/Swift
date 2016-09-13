//
//  UIColor.swift
//
//  Created by Andrei Gubceac on 4/21/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

extension UIColor {
    /*HEX*/
    class func hexColor(_ hexString : String) -> UIColor {
        /** https://gist.github.com/arshad/de147c42d7b3063ef7bc */
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

protocol UIColorProtocol {
    static func viewControllerMainBackgroundColor() -> UIColor
    static func viewControllerSecondaryBackgroundColor() -> UIColor
    
    static func textColor() -> UIColor

}
