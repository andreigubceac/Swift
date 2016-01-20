//
//  ViewControllerProtocol.swift
//  FourSynapses
//
//  Created by Andrei Gubceac on 1/20/16.
//  Copyright © 2016 4 Synapses. All rights reserved.
//

import UIKit

typealias ViewControllerProtocolBlock = (viewController : UIViewController, info : AnyObject?) -> Void

protocol ViewControllerProtocol
{
    var info : AnyObject? { get set}
    var delegateBlock : ViewControllerProtocolBlock? { get set}
    
/*
    init(info : AnyObject)
    init(delegateBlock : ViewControllerProtocolBlock)
    init(info : AnyObject, delegateBlock : ViewControllerProtocolBlock)
*/    
}


