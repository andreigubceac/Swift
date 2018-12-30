//
//  DateFormatter.swift
//
//  Created by Andrei Gubceac on 26/10/2018.
//  Copyright © 2018 Andrei Gubceac. All rights reserved.
//

import Foundation

extension DateFormatter {
    
    public class func sharedFormatter(with format: String? = "yyyy-MM-dd HH:mm", timeZone: TimeZone? = TimeZone.autoupdatingCurrent, locale: Locale? = Locale(identifier: "en_US_POSIX")) -> DateFormatter {
        let indentifier = Thread.current.hash
        if let formatter = Thread.current.threadDictionary[indentifier] as? DateFormatter{
          formatter.locale        = locale
          formatter.dateFormat    = format
          formatter.timeZone      = timeZone
          return formatter
        }else{
            let dateFormatter           = DateFormatter()
            dateFormatter.locale        = locale
            dateFormatter.dateFormat    = format
            dateFormatter.timeZone      = timeZone
            Thread.current.threadDictionary[indentifier] = dateFormatter
            return dateFormatter
        }
        
    }
    
}
