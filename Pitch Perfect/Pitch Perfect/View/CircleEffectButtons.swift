//
//  CircleEffectButtons.swift
//  Pitch Perfect
//
//  Created by Corey Baines on 30/6/16.
//  Copyright © 2016 Corey Baines. All rights reserved.
//

import Foundation
import UIKit

class CircleEffectButtons: UIImageView {
    
    override func awakeFromNib() {
        layer.cornerRadius = frame.size.width/2
        layer.masksToBounds = true
        layer.borderWidth = 3
        layer.borderColor = buttonBoarderMain
        
    }
}