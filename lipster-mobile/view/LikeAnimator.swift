//
//  LikeAnimator.swift
//  lipster-mobile
//
//  Created by Bank on 13/8/2562 BE.
//  Copyright © 2562 Bank. All rights reserved.
//

import UIKit

class LikeAnimator {
    
    let container: UIView
    let layoutConstraint: NSLayoutConstraint
    let popupSize: CGFloat
    
    init(container: UIView, layoutConstraint: NSLayoutConstraint, popupSize: CGFloat) {
        self.container = container
        self.layoutConstraint = layoutConstraint
        self.popupSize = popupSize
    }
    
    func animate(completion: @escaping () -> Void) {
        layoutConstraint.constant = popupSize
        
        UIView.animate(
            withDuration: 0.7,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 2,
            options: .curveLinear,
            animations: { [weak self] in
                self?.container.layoutIfNeeded()
            }
        ) { [weak self] (_) in
            self?.layoutConstraint.constant = 0
            
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self?.container.layoutIfNeeded()
                    completion()
                }
            )
        }
    }
}
