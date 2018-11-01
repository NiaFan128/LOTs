//
//  UIImage+Effect.swift
//  LOTs
//
//  Created by 乃方 on 2018/10/1.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

extension UIView {
    
    func backgroundBorder() {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 15
        self.layer.shadowOpacity = 1
//        self.layer.shouldRasterize = true
        self.layer.cornerRadius = 10
        
    }
    
    func backgroundBord() {
        
        self.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10
        
    }
    
    func corner(corner: CGFloat = 6) {
        
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
        
    }
    
    func titleShadow(color: UIColor = .black) {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        
    }
    
    func roundCorner() {
        
        self.layer.cornerRadius = (self.frame.width) / 2
        self.layer.masksToBounds = true
        
    }
    
    func cornerBorder() {
        
        self.layer.cornerRadius = (self.frame.width) / 2
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    
    }
    
    func shadowRadius() {
        
        self.layer.borderColor = #colorLiteral(red: 0.8274509804, green: 0.3529411765, blue: 0.4, alpha: 1)
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 6
        self.layer.shadowColor = #colorLiteral(red: 0.9019607843, green: 0.631372549, blue: 0.6588235294, alpha: 1)
        
        self.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        
    }
    
}

extension UIView {
    
    /// Constrain 4 edges of `self` to specified `view`.
    func edges(to view: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
        
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: left),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom)
            ])
    
    }
    
    enum AnimationKeyPath: String {
        
        case opacity = "opacity"
    
    }
    
    func flash(animation: AnimationKeyPath ,withDuration duration: TimeInterval = 0.5, repeatCount: Float = 5){
        
        let flash = CABasicAnimation(keyPath: AnimationKeyPath.opacity.rawValue)
        flash.duration = duration
        flash.fromValue = 1 // alpha
        flash.toValue = 0 // alpha
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = repeatCount
        
        layer.add(flash, forKey: nil)
        
    }
    
    func fadeTo(_ alpha: CGFloat, duration: TimeInterval? = 0.3) {
        
        DispatchQueue.main.async {
        
            UIView.animate(withDuration: duration != nil ? duration! : 0.5) {
                self.alpha = alpha
            
            }
        
        }
    
    }
    
    func fadeIn(_ duration: TimeInterval? = 1.0) {
        
        fadeTo(1.0, duration: duration)
    
    }
    
    func fadeOut(_ duration: TimeInterval? = 0.6) {
    
        fadeTo(0.0, duration: duration)
    
    }
    
}
