//
//  UIViewExtensions.swift
//  Pitch Perfect
//
//  Created by Corey Baines on 2/7/16.
//  Copyright © 2016 Corey Baines. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeIn() {
        // Move our fade out code from earlier
        self.hidden = false
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: { void in
                
                self.alpha = 0.0
                
        })
    }
}