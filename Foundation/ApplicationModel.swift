//
//  ApplicationModel.swift
//
//  Created by Andrei Gubceac on 5/3/16.
//  Copyright © 2016. All rights reserved.
//

import Foundation

protocol ApplicationModelProtocol: Codable {
    var identifier : AnyHashable? { get }
    var name : String? { get }
    var toDictionary: Dictionary<AnyHashable,Any> { get }
    
    var date : Date? { get set }
}

open class ApplicationModel {
    var date: Date?
    func test() {
    }
}

