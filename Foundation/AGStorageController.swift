//
//  AGStorageController.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import Foundation

typealias StoreResultBlock = (result : AnyObject?, fromLocal : Bool) -> Void
typealias StoreProgressBlock = (message : String) -> Void

class AGStorageController {
    private let bundleIdentifier    = NSBundle.mainBundle().infoDictionary?["CFBundleIdentifier"] as! String

    private let operationQueue = NSOperationQueue()

    deinit {
        /*Stop All connections*/
        operationQueue.cancelAllOperations()
    }
    
    init() {
    }
    
    func runBackgroundTask(block : ()->AnyObject?, completion : ((result : AnyObject?) -> Void)? = nil ) {
        operationQueue.addOperationWithBlock { () -> Void in
            let result = block()
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                completion?(result: result)
            })
        }
    }
    
    /*API*/
    func processAPIResponse(result : AnyObject?, completion : StoreResultBlock) {
        if result is NSDictionary || result is NSArray {
            completion(result: result, fromLocal: false)
        }
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if let error = result as? NSError {
                    completion(result: error, fromLocal: false)
                }
                else {
                    let error = NSError(domain: self.bundleIdentifier, code: 500, userInfo: [NSLocalizedDescriptionKey : "An unexpected error occured"])
                    completion(result: error, fromLocal: false)
                }
            })
        }
   }

}