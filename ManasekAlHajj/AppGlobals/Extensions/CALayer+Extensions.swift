//
//  CALayer.swift
//  SelfServices
//
//  Created by Owen on 2018-06-11.
//  Copyright © 2018 Rent Centric. All rights reserved.
//

import UIKit

extension CALayer {
    
    func addRoundBorder(radius: CGFloat, color: UIColor, thickness: CGFloat) {
        self.cornerRadius = radius
        self.borderColor = color.cgColor
        self.borderWidth = thickness
    }
    
    func addOneEdgeBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness,
                                  width: UIScreen.main.bounds.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}

