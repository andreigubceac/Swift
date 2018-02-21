//
//  ApplicationModel+Analytics.swift
//
//  Created by Andrei Gubceac.
//

import Foundation

extension ApplicationModel : AGAnalyticsEventParameters {
    
    var eventParameters: Dictionary<String, String> {
        var _params = [String:String]()
        _params[ApplicationModel.identifierKey()] = identifier as? String
        _params[ApplicationModel.nameKey()]       = name
        return _params
    }
}

extension Encodable {

    var eventParameters: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

