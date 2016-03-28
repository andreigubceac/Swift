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
    
/*
    init(info : AnyObject)
    init(delegateBlock : ViewControllerProtocolBlock)
    init(info : AnyObject, delegateBlock : ViewControllerProtocolBlock)
*/    
}


extension UIViewController {
    
    var storage : StorageController? {
        get {
            return AppDelegate.shared.storage
        }
    }
    
    class func dismissViewControllerSelector() -> Selector {
        return NSSelectorFromString("dismissViewControllerAnimated");
    }
    
    func dismissViewControllerAnimated() {
        self.dismissViewControllerAnimated(true , completion: nil)
    }
    
    
    func loadData(forced : Bool) {
        /*Override me*/
    }
    
    func loadData() {
        self.loadData(false)
    }
    
    func updateUI() {
        /*Override me*/
    }
}