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
    func toDictionary() -> Dictionary<String,AnyObject>
    
    @objc optional var date : Date? { get set }
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
    
    convenience init() {
        self.init(dictionary: [self.dynamicType.identifierKey(): UUID.init().uuidString])
    }
    
    func update(_ dictionary : Dictionary<String, AnyObject>) {
        for (key, value) in dictionary {
            _dictionary.updateValue(value, forKey: key)
        }
    }
    
    func setValue(_ value : AnyObject?, for key : String) {
        _dictionary[key] = value
    }
    
    @objc func toDictionary() -> Dictionary<String,AnyObject> {
        return _dictionary!
    }
    
    /*ApplicationModelProtocol*/
    @objc var identifier: String? {
        if let id = self[self.dynamicType.self.identifierKey()] as? NSNumber {
            return id.stringValue
        }
        return self[self.dynamicType.self.identifierKey()] as? String
    }
    
    @objc var name: String? {
        return self[self.dynamicType.self.nameKey()] as? String
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
