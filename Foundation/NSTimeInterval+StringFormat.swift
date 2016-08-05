//
//  NSTimeInterval+StringFormat.swift
//
//  Created by Andrei Gubceac on 3/18/16.
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    func formatHrMin() -> String {
        var mm = Int(self / 60)
        let hh = Int(mm / 60)
        if hh > 0 {
            mm %= 60
        }
        return ("" + (hh > 0 ?"\(hh) hr" + (hh == 1 ? "" : "s") : "") + (mm > 0 ? " \(mm) min" : "00 min")).trimmingCharacters(in: CharacterSet.whitespaces)
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
