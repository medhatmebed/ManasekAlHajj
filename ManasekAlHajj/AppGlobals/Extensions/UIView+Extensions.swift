//
//  UIView.swift
//  SelfServices
//
//  Created by Owen on 2018-06-11.
//  Copyright © 2018 Rent Centric. All rights reserved.
//

import UIKit

extension UIView {
    class func loadNib<T: UIView>(_ viewType: T.Type) -> T {
        let className = String.className(viewType)
        return Bundle(for: viewType).loadNibNamed(className, owner: nil, options: nil)!.first as! T
    }
    
    class func loadNib() -> Self {
        return loadNib(self)
    }
    
    func addBottomSideShadow(color:UIColor, offset: CGFloat, radius: CGFloat, opacity: Float) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height:offset)
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = false
    }
    
    func addShadow(color:UIColor, offsetSize: CGSize, radius: CGFloat, opacity: Float, isMasksToBounds: Bool) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offsetSize
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.masksToBounds = isMasksToBounds
    }
    
    func setRadius(radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2;
        self.layer.masksToBounds = true;
    }
    
    func roundCornersWithBorder(borderWidth: CGFloat, borderColor: UIColor, radius: CGFloat, isClips: Bool) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.clipsToBounds = isClips
    }
    
    func roundSpecificCorners(borderWidth: CGFloat, borderColor: UIColor, isClips: Bool, radius: CGFloat = APP_ROUND_BUTTON_CORNER_RADIUS, roundConers: UIRectCorner) {
        
        let path = UIBezierPath(roundedRect: self.bounds,
                                byRoundingCorners: roundConers,
                                cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
        self.clipsToBounds = isClips
    }
    
    func fadeIn(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
    func blink() {
        self.alpha = 0.2
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    func popout(fromView view: UIView, scaleX: CGFloat = 1.5, scaleY: CGFloat = 1.2, duration: Double = 1) {
        
        self.center = view.center
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [],  animations: {
            
            self.alpha = 1
            self.transform = .identity
        })
    }
    
    func popIn()
    {
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion:{(finished : Bool)  in
            if (finished)
            {      self.alpha = 1.0; }
        });
    }
    
    func movePopIn()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {      self.alpha = 0.0; }
        });
    }
    
    func repeatChangeBGColor(originalColor: UIColor, changedColor: UIColor) {
        self.backgroundColor = originalColor
        
        UIView.animate(withDuration: 1.0, delay: 0.0, options: [.curveLinear, .repeat, .autoreverse], animations: {
            self.backgroundColor = changedColor
        }, completion: nil)
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    func drawDashLine(start p0: CGPoint, end p1: CGPoint, color: UIColor) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.
        
        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        self.layer.addSublayer(shapeLayer)
    }
}
