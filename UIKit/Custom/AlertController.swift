//
//  AlertController.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func alertController(_ title : String?, message : String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .alert)
    }

    class func actionSheetController(_ title : String?, message : String?) -> UIAlertController {
        return UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    }

}

extension UIViewController {
    
    func presentAlert(_ title : String? = nil, message : String? = nil, animated : Bool? = true, completion : (()->Void)? = nil) -> UIAlertController {
        let alert = UIAlertController.alertController(title, message: message)
        present(alert, animated: animated!, completion: completion);
        return alert
    }
    
    /*Custom*/
    func presentAlertInfo(_ title : String? = nil, message : String? = nil, animated : Bool? = true, completion : (()->Void)? = nil) -> UIAlertController{
        let alert = presentAlert(title, message: message, animated: animated, completion: completion)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: "Dismiss"), style: .cancel, handler: nil))
        return alert
    }
    
    func presentActionSheet(_ title : String? = nil , message : String? = nil, animated : Bool? = true, completion : (()->Void)? = nil) -> UIAlertController {
        let alert = UIAlertController.actionSheetController(title, message: message)
        present(alert, animated: animated!, completion: completion);
        return alert
    }
    
}
