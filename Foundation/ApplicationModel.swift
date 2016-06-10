//
//  ApplicationModel.swift
//  Whimzer
//
//  Created by Andrei Gubceac on 5/3/16.
//  Copyright © 2016 Whimzer Inc. All rights reserved.
//

import Foundation

@objc protocol ApplicationModelProtocol {
    var identifier : String { get }
    var name : String? { get }
    func toDictionary() -> Dictionary<String,AnyObject>
    
    optional var date : NSDate? { get set }
}

class ApplicationModel : ApplicationModelProtocol {
    private var _dictionary : Dictionary<String, AnyObject>!

    class func identifierKey() -> String {
        return "Id"
    }
    
    class func nameKey() -> String {
        return "Name"
    }

    init(dictionary : Dictionary<String, AnyObject>) {
        _dictionary = dictionary
    }
    
    func update(dictionary : Dictionary<String, AnyObject>) {
        _dictionary = dictionary
    }
    
    func setValue(value : AnyObject?, for key : String) {
        _dictionary[key] = value
    }
    
    @objc func toDictionary() -> Dictionary<String,AnyObject> {
        return _dictionary!
    }
    
    /*ApplicationModelProtocol*/
    @objc var identifier: String {
        if let id = _dictionary[self.dynamicType.self.identifierKey()] as? NSNumber {
            return id.stringValue
        }
        return _dictionary[self.dynamicType.self.identifierKey()] as! String
    }
    
    @objc var name: String? {
        return _dictionary[self.dynamicType.self.nameKey()] as? String
    }

    subscript(key : String) -> AnyObject? {
        get {
            return _dictionary[key]
        }
        set {
            _dictionary[key] = newValue
        }
    }
}

extension ApplicationModel : CustomStringConvertible {
    
    var description: String {
        return "\(self) : [\(_dictionary)]"
    }

}