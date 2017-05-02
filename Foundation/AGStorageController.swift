//
//  AGStorageController.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import Foundation

typealias StoreResultBlock = (_ result: Any?, _ fromLocal: Bool) -> Void
typealias StoreProgressBlock = (_ message: String) -> Void

class AGStorageController {
    static let bundleIdentifier = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String

    fileprivate let operationQueue = OperationQueue()

    static var applicationCacheDirectory : URL = {
        var _cacheUrl = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        _cacheUrl = _cacheUrl?.appendingPathComponent(AGStorageController.bundleIdentifier)
        return _cacheUrl!
    }()
    
    deinit {
        /*Stop All connections*/
        operationQueue.cancelAllOperations()
    }
    
    init() {
        if FileManager.default.fileExists(atPath: AGStorageController.applicationCacheDirectory.path) == false {
            do {
                let _ = try FileManager.default.createDirectory(at: AGStorageController.applicationCacheDirectory, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error {
                debugPrint(error)
            }
        }
    }
    
    func runBackgroundTask(_ block: @escaping ()->Any?, completion: ((_ result : Any?) -> Void)? = nil ) {
        operationQueue.addOperation { () -> Void in
            let result = block()
            OperationQueue.main.addOperation({ () -> Void in
                completion?(result)
            })
        }
    }
    
    func runMainThreadTask(_ block: @escaping () -> Void) {
        OperationQueue.main.addOperation(block);
    }
    
    /*Storage*/
    /*Override this*/
    func canDisplayHomeViewController() -> Bool {
        return true
    }
    
    /*Write*/
    func writeJSONResponse(_ response: Any, toDisk identifier: String, atURL url: URL = AGStorageController.applicationCacheDirectory) throws {
        let data = try JSONSerialization.data(withJSONObject: response, options: JSONSerialization.WritingOptions.prettyPrinted)
        let fileUrl = url.appendingPathComponent(identifier)
        try data.write(to: fileUrl, options: [NSData.WritingOptions.atomic])
    }
    
    /*Delete*/
    func deleteJSONFileFor(_ identifier: String, atURL url: URL = AGStorageController.applicationCacheDirectory) throws {
        let fileUrl = url.appendingPathComponent(identifier)
        try FileManager.default.removeItem(at: fileUrl)
    }
    
    /*Read*/
    func jsonFileFor(_ identifier: String, atURL url: URL = AGStorageController.applicationCacheDirectory) throws -> Any? {
        let fileUrl = url.appendingPathComponent(identifier)
        if let data = try? Data(contentsOf: fileUrl) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
            }
            catch let error {
                throw error
            }
        }
        throw NSError(domain: AGStorageController.bundleIdentifier, code: 500, userInfo: [NSLocalizedDescriptionKey: "Unable to read file at \(fileUrl)"])
    }
    
    /*API*/
    func processAPIResponse(_ result: Any?, completion: @escaping StoreResultBlock) {
        if result is Dictionary<AnyHashable,Any> || result is Array<Any> {
            completion(result, false)
        }
        else {
            if let error = result as? NSError {
                completion(error, false)
            }
            else {
                completion(NSError(domain: AGStorageController.bundleIdentifier, code: 500, userInfo: [NSLocalizedDescriptionKey : "An unexpected error occured"]), false)
            }
        }
   }

}
