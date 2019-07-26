//
//  UIButton+Extensions.swift
//  SelfServices
//
//  Created by Owen on 2018-06-11.
//  Copyright © 2018 Rent Centric. All rights reserved.
//

import UIKit

extension UIButton {
    func roundCorner(radius: CGFloat = APP_ROUND_BUTTON_CORNER_RADIUS, color: UIColor = .clear) {
        self.layer.addRoundBorder(radius: radius, color: color, thickness: 1)
        self.clipsToBounds = true
    }
    
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}
