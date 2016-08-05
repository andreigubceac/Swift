//
//  AGStorageController.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import Foundation

typealias StoreResultBlock = (result : Any?, fromLocal : Bool) -> Void
typealias StoreProgressBlock = (message : String) -> Void

class AGStorageController {
    let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as! String

    private let operationQueue = OperationQueue()

    lazy var applicationCacheDirectory : URL = {
        var _cacheUrl = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        _cacheUrl = _cacheUrl?.appendingPathComponent(self.bundleIdentifier);
        return _cacheUrl!
    }()
    
    deinit {
        /*Stop All connections*/
        operationQueue.cancelAllOperations()
    }
    
    init() {
    }
    
    func runBackgroundTask(_ block : ()->AnyObject?, completion : ((result : AnyObject?) -> Void)? = nil ) {
        operationQueue.addOperation { () -> Void in
            let result = block()
            OperationQueue.main.addOperation({ () -> Void in
                completion?(result: result)
            })
        }
    }
    
    func runMainThreadTask(_ block : () -> Void) {
        OperationQueue.main.addOperation(block);
    }
    
    /*Storage*/
    /*Override this*/
    func canDisplayHomeViewController() -> Bool {
        return true
    }
    
    /*Write*/
    func writeJSONResponse(_ response : AnyObject, toDisk identifier : String, atURL url: URL) throws {
        do {
            let data = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
            let fileUrl = URL(string: identifier, relativeTo: url)
            if ((try? data.write(to: fileUrl!, options: [NSData.WritingOptions.atomic])) != nil) == false {
                throw NSError(domain: self.bundleIdentifier, code: 500, userInfo: [NSLocalizedDescriptionKey : "Failed all attempts to save reponse to disk: \(response)"])
            }
        }
        catch let error {
            throw error
        }
    }
    
    func writeJSONResponse(_ response : AnyObject, toDisk identifier : String) throws {
        try self.writeJSONResponse(response, toDisk: identifier, atURL: self.applicationCacheDirectory)
    }
    
    /*Delete*/
    func deleteJSONFileFor(_ identifier : String, atURL url : URL) throws {
        let fileUrl = URL(string: identifier, relativeTo: url)
        try FileManager.default.removeItem(at: fileUrl!)
    }
    
    func deleteJSONFileFor(_ identifier : String) throws {
        try self.deleteJSONFileFor(identifier, atURL: self.applicationCacheDirectory)
    }
    
    /*Read*/
    func jsonFileFor(_ identifier : String, atURL url : URL) throws -> AnyObject? {
        let fileUrl = URL(string: identifier, relativeTo: url)
        if let data = try? Data(contentsOf: fileUrl!) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            }
            catch let error {
                throw error
            }
        }
        throw NSError(domain: self.bundleIdentifier, code: 500, userInfo: [NSLocalizedDescriptionKey : "Unable to read file at \(fileUrl)"])
    }
    
    func jsonFileFor(_ identifier : String) throws -> AnyObject? {
        return try self.jsonFileFor(identifier, atURL: self.applicationCacheDirectory)
    }

    /*API*/
    func processAPIResponse(_ result : AnyObject?, completion : StoreResultBlock) {
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
