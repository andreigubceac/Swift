//
//  AppSessionProtocol.swift
//
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

import Foundation

protocol AppSessionProtocol {

    func openAppSession()
    
    func closeAppSession()
    
    func handleError(error : NSError)
}