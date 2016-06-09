//
//  AppNavigationProtocol.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import UIKit

@objc protocol AppNavigationProtocol {

    var topViewController : UIViewController { get }
    
    optional func showWelcomeViewController(animated : Bool)
    optional func showHomeViewController(animated : Bool)
    
}