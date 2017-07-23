//
//  AppSessionProtocol.swift
//
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import UIKit

protocol AppSessionProtocol {

    func openAppSession()
    
    func closeAppSession()
    
    func handle(success: String?)

    func handle(error: Error)
    
    func handle(progress message: Any)
}

extension UIApplicationDelegate {
    
    static var shared : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
}
