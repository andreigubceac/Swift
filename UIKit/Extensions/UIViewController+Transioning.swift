//
//  UIViewController+Transioning.swift
//
//  Created by Andrei Gubceac on 25/12/2018.
//  Copyright © 2018. All rights reserved.
//

import UIKit

extension UIViewController {
  static private var transitioningControllerKey = "transitioningController"
  
  var transitioningController: UIViewControllerTransitioningDelegate? {
    set {
      objc_setAssociatedObject(self, &UIViewController.transitioningControllerKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
      modalPresentationStyle = .custom
      transitioningDelegate = transitioningController
    }
    get {
      return objc_getAssociatedObject(self, &UIViewController.transitioningControllerKey) as? UIViewControllerTransitioningDelegate
    }
  }
}
