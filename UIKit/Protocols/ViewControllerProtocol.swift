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
  @objc class func storyBoard(file: UIStoryboard) -> UIViewController {
    return file.instantiateInitialViewController() ?? file.instantiateViewController(withIdentifier: String(describing: self))
  }

  @objc class func storyBoard(name: String = "") -> UIViewController {
    let sboard = UIStoryboard(name: (name.count > 0 ? name : String(describing: self)), bundle: nil)
    return self.storyBoard(file: sboard)
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
