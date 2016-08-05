//
//  AppSessionProtocol.swift
//
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import UIKit

protocol AppSessionProtocol {

    func openAppSession()
    
    func closeAppSession()
    
    func handleError(_ error : NSError)
}

extension UIApplicationDelegate {
    
    static var shared : AppDelegate {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }
    
}
