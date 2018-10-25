//
//  MainFoodCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var disabledHighlightedAnimation = false
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        containerView.corner()
        profileImageView.cornerBorder()
        titleLabel.titleShadow()
        
    }
    
    
    func resetTransform() {
        
        transform = .identity
    
    }
    
    func freezeAnimations() {
        
        disabledHighlightedAnimation = true
        layer.removeAllAnimations()
    
    }
    
    func unfreezeAnimations() {
        
        disabledHighlightedAnimation = false
    
    }
    
}
