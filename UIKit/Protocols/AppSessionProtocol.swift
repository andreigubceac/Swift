//
//  AppSessionProtocol.swift
//
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import UIKit

@objc protocol AppSessionProtocol {

    func openAppSession()
    
    func closeAppSession()
    
    @objc optional func handle(success: String?)

    @objc optional func handle(error: NSError)
    
    @objc optional func handle(progress message: Any)
}

extension UIApplicationDelegate {
    
    static var shared : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
}
