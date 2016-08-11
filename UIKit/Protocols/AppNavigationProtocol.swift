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
    
    var rootViewController : UIViewController { get }
    
    optional func customRootViewController(from : UIViewController) -> UIViewController?
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
        else if let vc = customRootViewController?(fromViewController) {
            return topViewController(vc)
        }
        return fromViewController
    }
    
    var topViewController : UIViewController {
        return topViewController(rootViewController)
    }
    
}