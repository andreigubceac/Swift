//
//  ViewControllerProtocol.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

typealias ViewControllerProtocolBlock = (_ viewController : UIViewController, _ info : Any?) -> Void

protocol ViewControllerProtocol : class
{
    var info : Any? { get set}
    var delegateBlock : ViewControllerProtocolBlock? { get set}
    
}


extension UIViewController {
    var application : AppDelegate {
        return AppDelegate.shared
    }
    
    var storage : AGStorageController {
        return application.storage!
    }
    
    class func dismissViewControllerSelector() -> Selector {
        return NSSelectorFromString("dismissViewControllerAnimated");
    }
    
    func dismissViewControllerAnimated() {
        self.dismiss(animated: true , completion: nil)
    }
    
    
    func loadData(_ forced : Bool = false) {
        /*Override me*/
    }
    
    func updateUI() {
        /*Override me*/
    }
}

extension UINavigationController {
    
}
