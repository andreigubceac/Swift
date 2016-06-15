//
//  AlertController.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func alertController(title : String?, message : String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    }

    class func actionSheetController(title : String?, message : String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.ActionSheet)
    }

}

extension UIViewController {
    
    func presentAlertWith(title : String?, message : String?, animated : Bool? = true, completion : (Void->Void)? = nil) -> UIAlertController {
        let alert = UIAlertController.alertController(title, message: message)
        presentViewController(alert, animated: animated!, completion: completion);
        return alert
    }
    
    /*Custom*/
    func presentAlertInfo(title : String?, message : String?, animated : Bool? = true, completion : (Void->Void)? = nil) -> UIAlertController{
        let alert = self.presentAlertWith(title, message: message, animated: animated, completion: completion)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: UIAlertActionStyle.Cancel, handler: nil))
        return alert
    }
    
    func presentActionSheetWith(title : String?, message : String?, animated : Bool? = true, completion : (Void->Void)? = nil) -> UIAlertController {
        let alert = UIAlertController.actionSheetController(title, message: message)
        presentViewController(alert, animated: animated!, completion: completion);
        return alert
    }
    
}