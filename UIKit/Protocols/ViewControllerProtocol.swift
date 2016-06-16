//
//  ViewControllerProtocol.swift
//  FourSynapses
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 4 Synapses. All rights reserved.
//

import UIKit

typealias ViewControllerProtocolBlock = (viewController : UIViewController, info : Any?) -> Void

protocol ViewControllerProtocol : class
{
    var info : Any? { get set}
    var delegateBlock : ViewControllerProtocolBlock? { get set}
    
}


extension UIViewController {
    
    var storage : StorageController? {
        return application.storage
    }
    
    var application : AppDelegate {
        return AppDelegate.shared
    }
    
    class func dismissViewControllerSelector() -> Selector {
        return NSSelectorFromString("dismissViewControllerAnimated");
    }
    
    @objc func dismissViewControllerAnimated() {
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    
    
    func loadData(forced : Bool) {
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
    
    override func loadData(forced: Bool) {
        topViewController?.loadData(forced)
    }
    
    override func updateUI() {
        topViewController?.updateUI()
    }
}