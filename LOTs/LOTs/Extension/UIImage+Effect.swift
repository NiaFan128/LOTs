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
        self.layer.shouldRasterize = true
        self.layer.cornerRadius = 10
        
    }
    
    func corner(corner: CGFloat = 6) {
        
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
        
    }
    
}

extension UIImageView {
    
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
    
}


