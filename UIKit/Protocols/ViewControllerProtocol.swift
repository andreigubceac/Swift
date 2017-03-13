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
    
    var storage : StorageController {
        return application.storage!
    }
    
    class func dismissViewControllerSelector() -> Selector {
        return NSSelectorFromString("dismissViewControllerAnimated");
    }
    
    @objc func dismissViewControllerAnimated() {
        self.dismiss(animated: true , completion: nil)
    }
    
    
    func loadData(_ forced : Bool) {
        /*Override me*/
    }
    
    func loadData() {
        loadData(false)
    }
    
    func updateUI() {
        /*Override me*/
    }
}

extension UINavigationController {
    
    override func loadData() {
        topViewController?.loadData()
    }
    
    override func loadData(_ forced: Bool) {
        topViewController?.loadData(forced)
    }
    
    override func updateUI() {
        topViewController?.updateUI()
    }
}
