//
//  ApplicationModel.swift
//
//  Created by Andrei Gubceac on 5/3/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

@objc protocol ApplicationModelProtocol {
    var identifier : String? { get }
    var name : String? { get }
    func toDictionary() -> Dictionary<String,Any>
    
    @objc optional var date : Date? { get set }
}

class ApplicationModel : ApplicationModelProtocol {
    internal var _dictionary : Dictionary<String, Any>!
    
    static func identifierKey() -> String {
        return "Id"
    }
    
    static func emptyObject(with identifier : String) -> Self {
        return self.init(dictionary: [self.identifierKey() : identifier])
    }
    
    static func nameKey() -> String {
        return "Name"
    }

    required init(dictionary : Dictionary<String, Any>) {
        _dictionary = dictionary
    }
    
    convenience init() {
        self.init(dictionary: [type(of: self).identifierKey(): UUID.init().uuidString])
    }
    
    func update(_ dictionary : Dictionary<String, Any>) {
        for (key, value) in dictionary {
            _dictionary.updateValue(value, forKey: key)
        }
    }
    
    @objc func toDictionary() -> Dictionary<String,Any> {
        return _dictionary!
    }
    
    /*ApplicationModelProtocol*/
    @objc var identifier: String? {
        if let id = self[type(of: self).identifierKey()] as? NSNumber {
            return id.stringValue
        }
        return self[type(of: self).identifierKey()] as? String
    }
    
    @objc var name: String? {
        return self[type(of: self).nameKey()] as? String
    }

    subscript(key : String) -> Any? {
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
