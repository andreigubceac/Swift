//
//  ApplicationModel+Analytics.swift
=//
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
