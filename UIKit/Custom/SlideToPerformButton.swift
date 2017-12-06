//
//  SlideToPerformButton.swift
//
//  Created by Andrei Gubceac on 9/1/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

/*
    
 Initial State from XIB
 
    set an image for normal state in xib.
 
    add a target for ValueChanged Event
 
 */

class SlideToPerformButton: UIButton {
    fileprivate var arrowImageView : UIImageView! = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(dragInside)))
        arrowImageView = UIImageView(image: image(for: .normal))
        setImage(nil, for: .normal)
        addSubview(arrowImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        arrowImageView.center = titleLabel!.center
        arrowImageView.center.x = titleLabel!.left - arrowImageView.width - 10
    }
    
    @objc private func dragInside(_ g : UIPanGestureRecognizer) {
        if g.state == .began {
        }
        else if g.state == .changed {
            let loc = g.location(in: g.view)
            if bounds.contains(loc) {
                let tr = g.translation(in: g.view)
                if tr.x > 0 {
                    if (arrowImageView.center.x + tr.x) < (titleLabel!.right + 20) {
                        arrowImageView?.transform = CGAffineTransform.init(translationX: tr.x, y: 0)
                        titleLabel?.alpha = 1 - tr.x / titleLabel!.width
                    }
                    else {
                        g.isEnabled = false
                    }
                }
            }
            else {
                isUserInteractionEnabled = false
                g.isEnabled = false
            }
        }
        else {
            if g.isEnabled || isUserInteractionEnabled == false {
                UIView.animate(withDuration: 0.15, animations: {
                    self.arrowImageView?.transform = CGAffineTransform.identity
                    self.titleLabel?.alpha = 1.0
                    }, completion: { (f) in
                        g.isEnabled = true
                        self.isUserInteractionEnabled = true
                })
            }
            else {
                g.isEnabled = true
                sendActions(for: .valueChanged)
                arrowImageView?.transform = CGAffineTransform.identity
                titleLabel?.alpha = 1.0
            }
        }
    }
}
