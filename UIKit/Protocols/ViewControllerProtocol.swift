//
//  ViewControllerProtocol.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

typealias ViewControllerProtocolBlock = (_ viewController : UIViewController, _ info : Any?) -> Void

@objc protocol ViewControllerProtocol: NSObjectProtocol {
    var info : Any? { get set}
    var delegateBlock : ViewControllerProtocolBlock? { get set}
    
    @objc optional func delegateAction(info: Any?)
    @objc optional func updateUI()
    @objc optional func loadData(forced: Bool)
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
    
}
