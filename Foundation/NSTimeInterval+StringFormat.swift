//
//  NSTimeInterval+StringFormat.swift
//
//  Created by Andrei Gubceac on 3/18/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func formatWeekDD() -> String {
        var mm = Int(self / 60)
        let hh = Int(mm / 60)
        if hh > 0 {
            mm %= 60
        }
        let dd = hh / 24
        if dd > 0 {
            if dd == 1 {
                return NSLocalizedString("yesterday", comment: "yesterday")
            }
            else if 2...6 ~= dd {
                return String(dd) + " " + NSLocalizedString("days", comment: "days")
            }
            let weeks = dd / 7
            return String(weeks) + " " + (weeks > 1 ? NSLocalizedString("weeks", comment: "weeks") :NSLocalizedString("week", comment: "week"))
        }
        if hh > 0 {
            return ("\(hh) hr" + (hh == 1 ? "" : "s"))
        }
        return formatHrMin()
    }
    
    func formatHrMin() -> String {
        var mm = Int(self / 60)
        let hh = Int(mm / 60)
        if hh > 0 {
            mm %= 60
        }
        return ("" + (hh > 0 ?"\(hh) hr" + (hh == 1 ? "" : "s") : "") + (mm > 0 ? " \(mm) min" : "")).trimmingCharacters(in: CharacterSet.whitespaces)
    }

    func formatHrMinSec() -> String {
        let ss = self.truncatingRemainder(dividingBy: 60)
        var mm = Int(self / 60)
        let hh = Int(mm / 60)
        if hh > 0 {
            mm %= 60
        }
        return ("" + (hh > 0 ? "\(hh) hr" + (hh > 1 ? "s" : "") : "") + (mm > 0 ? " \(mm) min" : "") + " \(ss) sec").trimmingCharacters(in: CharacterSet.whitespaces)
    }

}
