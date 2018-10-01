//
//  UILabel+Shadow.swift
//  LOTs
//
//  Created by 乃方 on 2018/10/1.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

extension UILabel {
    
    func titleShadow(color: UIColor = .black) {
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1.0
        self.layer.shadowOffset = CGSize.zero
        self.layer.masksToBounds = false
        
    }
    
    
}
