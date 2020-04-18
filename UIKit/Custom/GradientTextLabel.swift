//
//  GradientTextLabel.swift
//  Jumppi
//
//  Created by Andrei Gubceac on 4/19/20.
//  Copyright © 2020 Pickapal Inc. All rights reserved.
//

import UIKit

final class GradientTextLabel: PaddingLabel {
  override class var layerClass: AnyClass {
    return CAGradientLayer.self
  }
  
  private func setup() {
    let l = layer as! CAGradientLayer
    l.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor,
                UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor]
    l.opacity = 0.8
    l.startPoint = CGPoint(x: 0, y: 0)
    l.endPoint = CGPoint(x: 0, y: 1)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override init(frame: CGRect = .zero, inset: UIEdgeInsets = .zero) {
    super.init(frame: frame, inset: inset)
    setup()
  }
  
}
