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
    let bundleIdentifier = NSBundle.mainBundle().infoDictionary?["CFBundleIdentifier"] as! String

    private let operationQueue = NSOperationQueue()

    lazy var applicationCacheDirectory : NSURL = {
        var _cacheUrl = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.CachesDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
        _cacheUrl = _cacheUrl?.URLByAppendingPathComponent(self.bundleIdentifier);
        return _cacheUrl!
    }()
    
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
    
    func runMainThreadTask(block : () -> Void) {
        NSOperationQueue.mainQueue().addOperationWithBlock(block);
    }
    
    /*Storage*/
    /*Override this*/
    func canDisplayHomeViewController() -> Bool {
        return true
    }
    
    /*Write*/
    func writeJSONResponse(response : AnyObject, toDisk identifier : String, atURL url: NSURL) throws {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(response, options: NSJSONWritingOptions.PrettyPrinted)
            let fileUrl = NSURL(string: identifier, relativeToURL: url)
            if data.writeToURL(fileUrl!, atomically: true) == false {
                throw NSError(domain: self.bundleIdentifier, code: 500, userInfo: [NSLocalizedDescriptionKey : "Failed all attempts to save reponse to disk: \(response)"])
            }
        }
        catch let error {
            throw error
        }
    }
    
    func writeJSONResponse(response : AnyObject, toDisk identifier : String) throws {
        try self.writeJSONResponse(response, toDisk: identifier, atURL: self.applicationCacheDirectory)
    }
    
    /*Delete*/
    func deleteJSONFileFor(identifier : String, atURL url : NSURL) throws {
        let fileUrl = NSURL(string: identifier, relativeToURL: url)
        try NSFileManager.defaultManager().removeItemAtURL(fileUrl!)
    }
    
    func deleteJSONFileFor(identifier : String) throws {
        try self.deleteJSONFileFor(identifier, atURL: self.applicationCacheDirectory)
    }
    
    /*Read*/
    func jsonFileFor(identifier : String, atURL url : NSURL) throws -> AnyObject? {
        let fileUrl = NSURL(string: identifier, relativeToURL: url)
        if let data = NSData(contentsOfURL: fileUrl!) {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            }
            catch let error {
                throw error
            }
        }
        throw NSError(domain: self.bundleIdentifier, code: 500, userInfo: [NSLocalizedDescriptionKey : "Unable to read file at \(fileUrl)"])
    }
    
    func jsonFileFor(identifier : String) throws -> AnyObject? {
        return try self.jsonFileFor(identifier, atURL: self.applicationCacheDirectory)
    }

    /*API*/
    func processAPIResponse(result : AnyObject?, completion : StoreResultBlock) {
        if result is NSDictionary || result is NSArray {
            completion(result: result, fromLocal: false)
        }
        else {
            if let error = result as? NSError {
                completion(result: error, fromLocal: false)
            }
            else {
                let error = NSError(domain: self.bundleIdentifier, code: 500, userInfo: [NSLocalizedDescriptionKey : "An unexpected error occured"])
                completion(result: error, fromLocal: false)
            }
        }
   }

}