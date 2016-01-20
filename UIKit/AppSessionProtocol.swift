//
//  AppSessionProtocol.swift
//
//  Copyright © 2016 Andrei Gubceac. All rights reserved.
//

protocol AppSessionProtocol {

    func openAppSession()
    
    func closeAppSession()
    
    func handleError(error : NSError)
}