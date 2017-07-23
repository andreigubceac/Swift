//
//  AppNavigationProtocol.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import UIKit

protocol AppNavigationProtocol {

    var topViewController : UIViewController { get }
    
    func showWelcomeViewController(animated : Bool)
    func showHomeViewController(animated : Bool)
    
}

extension AppNavigationProtocol {
    
    func topViewController(fromViewController : UIViewController) -> UIViewController {
        /*Default UIKit*/
        if let vc = fromViewController.presentedViewController {
            return self.topViewController(fromViewController: vc)
        }
        else if let vc = fromViewController as? UINavigationController {
            return self.topViewController(fromViewController: vc.topViewController!)
        }
        else if let vc = fromViewController as? UITabBarController {
            return self.topViewController(fromViewController: vc.selectedViewController!)
        }
        return fromViewController
    }
}
