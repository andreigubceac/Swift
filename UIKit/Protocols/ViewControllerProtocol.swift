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
    
    @IBAction func dismissViewControllerAnimated() {
        dismiss(animated: true , completion: nil)
    }
    
    @objc func updateUI() {
        
    }
    
    @objc func loadData(forced: Bool = false) {
        
    }

}

extension UITableViewController {
    
    override func updateUI() {
        super.updateUI()
        tableView.reloadData()
    }
}

extension UICollectionViewController {
    
    override func updateUI() {
        super.updateUI()
        collectionView?.reloadData()
    }
}
