//
//  AGStorageController.swift
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import Foundation


class AGStorageController {
  static let bundleIdentifier = Bundle.main.infoDictionary!["CFBundleIdentifier"] as? String ?? ""
  private let backgroundQueue = DispatchQueue(label: AGStorageController.bundleIdentifier + "Queue")
  typealias StoreResultBlock<T> = (_ result: Swift.Result<T, Error>, _ fromLocal: Bool) -> Void
  typealias StoreProgressBlock = (_ message: String) -> Void

  static var applicationCacheDirectory : URL = {
        var _cacheUrl = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).last
        _cacheUrl = _cacheUrl?.appendingPathComponent(AGStorageController.bundleIdentifier)
        return _cacheUrl!
    }()
    
    deinit {
        /*Stop All connections*/
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
        backgroundQueue.async {
            let result = block()
            DispatchQueue.main.async {
                completion?(result)
            }
        }
    }
    
    func runMainThreadTask(_ block: @escaping () -> Void) {
        DispatchQueue.main.async(execute: block)
    }
    
    /*Storage*/
    
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
    func processAPIResponse<T>(_ result: Swift.Result<T,Error>, completion: @escaping StoreResultBlock<T>) {
        runBackgroundTask({ () -> Any? in
          switch result {
          case .success(let result):
            if result is Dictionary<AnyHashable,Any> || result is Array<Any> {
              return completion(Result.success(result), false)
            }
            else if result is Data {
              return completion(Result.success(result), false)
            }
            else {
              return completion(Result.failure(NSError(domain: AGStorageController.bundleIdentifier,
                                                       code: 500,
                                                       userInfo: [NSLocalizedDescriptionKey : "An unexpected error occured"])), false)
            }
          case .failure(let error):
            return completion(Result.failure(error), false)
          }
        })
   }

}
