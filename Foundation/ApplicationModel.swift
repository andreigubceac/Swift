//
//  ApplicationModel.swift
//
//  Created by Andrei Gubceac on 5/3/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

@objc protocol ApplicationModelProtocol {
    var identifier : AnyHashable? { get }
    var name : String? { get }
    func toDictionary() -> Dictionary<AnyHashable,Any>
    
    @objc optional var date : Date? { get set }
}

extension Encodable {
    var dictionary: [AnyHashable: Any] {
        do {
            if let dict = try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self), options: .allowFragments) as? [AnyHashable: Any] {
                return dict ?? [:]
            }
            return [:]
        }
    }
}

open class ApplicationModel : ApplicationModelProtocol, CustomStringConvertible {
    internal var _dictionary : Dictionary<AnyHashable, Any>!
    
    public class func identifierKey() -> String {
        return "Id"
    }
    
    public static func emptyObject(with identifier : AnyHashable) -> Self {
        return self.init(dictionary: [self.identifierKey() : identifier])
    }
    
    public class func nameKey() -> String {
        return "Name"
    }

    required public init(dictionary : Dictionary<AnyHashable, Any>) {
        _dictionary = dictionary
    }
    
    public convenience init() {
        self.init(dictionary: [type(of: self).identifierKey(): UUID.init().uuidString])
    }
    
    public func update(_ dictionary : Dictionary<AnyHashable, Any>) {
        for (key, value) in dictionary {
            _dictionary.updateValue(value, forKey: key)
        }
    }
    
    @objc public func toDictionary() -> Dictionary<AnyHashable,Any> {
        return _dictionary!
    }
    
    /*ApplicationModelProtocol*/
    @objc public var identifier: AnyHashable? {
        return self[type(of: self).identifierKey()] as? AnyHashable
    }
    
    @objc public var name: String? {
        return self[type(of: self).nameKey()] as? String
    }

    public subscript(key : AnyHashable) -> Any? {
        get {
            return _dictionary[key]
        }
        set {
            _dictionary[key] = newValue
        }
    }
    
    public var description: String {
        return _dictionary.description
    }

}

