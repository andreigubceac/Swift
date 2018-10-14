//
//  ViewControllerProtocol.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit
import ObjectiveC

typealias ViewControllerProtocolBlock = (_ viewController : UIViewController, _ info : Any?) -> Void

@objc protocol ViewControllerProtocol: NSObjectProtocol {
    var info : Any? { get set}
    var delegateBlock : ViewControllerProtocolBlock? { get set}
    
    @objc optional func delegateAction(info: Any?)
}

extension UIViewController {
    
    @objc class func storyBoard() -> UIViewController {
        let sboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return sboard.instantiateInitialViewController() ?? sboard.instantiateViewController(withIdentifier: String(describing: self))
    }
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
    
    @objc func loadData(forced: Bool) {
        
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


private var TransitioningControllerKey = "transitioningController"
extension UIViewController {

    var transitioningController: UIViewControllerTransitioningDelegate? {
        set {
            objc_setAssociatedObject(self, &TransitioningControllerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            modalPresentationStyle = .custom
            transitioningDelegate = transitioningController
        }
        get {
            return objc_getAssociatedObject(self, &TransitioningControllerKey) as? UIViewControllerTransitioningDelegate
        }
    }
}
