//
//  AppNavigationProtocol.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import UIKit

@objc protocol AppNavigationProtocol {

    optional func showWelcomeViewController(animated : Bool)
    optional func showHomeViewController(animated : Bool)
    
    var topViewController : UIViewController { get }
    
}

extension AppNavigationProtocol {
    
    func topViewController(fromViewController : UIViewController) -> UIViewController {
        /*Default UIKit*/
        if let vc = fromViewController.presentedViewController {
            return topViewController(vc)
        }
        else if let vc = fromViewController as? UINavigationController {
            return topViewController(vc.topViewController!)
        }
        else if let vc = fromViewController as? UITabBarController {
            return topViewController(vc.selectedViewController!)
        }
        return fromViewController
    }
        
}