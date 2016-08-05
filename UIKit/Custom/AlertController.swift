//
//  AlertController.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func alertController(_ title : String?, message : String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    }

    class func actionSheetController(_ title : String?, message : String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
    }

}

extension UIViewController {
    
    func presentAlertWith(_ title : String?, message : String?, animated : Bool? = true, completion : ((Void)->Void)? = nil) -> UIAlertController {
        let alert = UIAlertController.alertController(title, message: message)
        present(alert, animated: animated!, completion: completion);
        return alert
    }
    
    /*Custom*/
    func presentAlertInfo(_ title : String?, message : String?, animated : Bool? = true, completion : ((Void)->Void)? = nil) -> UIAlertController{
        let alert = self.presentAlertWith(title, message: message, animated: animated, completion: completion)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "Ok"), style: UIAlertActionStyle.cancel, handler: nil))
        return alert
    }
    
    func presentActionSheetWith(_ title : String?, message : String?, animated : Bool? = true, completion : ((Void)->Void)? = nil) -> UIAlertController {
        let alert = UIAlertController.actionSheetController(title, message: message)
        present(alert, animated: animated!, completion: completion);
        return alert
    }
    
}
