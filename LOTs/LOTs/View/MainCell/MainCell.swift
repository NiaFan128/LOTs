//
//  MainFoodCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Kingfisher

class MainCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        containerView.corner()
        profileImageView.cornerBorder()
        titleLabel.titleShadow()
        
    }
    
    func updateCellInfo(_ model: MainCellModel) {
        
        self.titleLabel.text = model.articleTitle
    
        let url = URL(string: model.profileImage)
        self.profileImageView.kf.setImage(with: url)

        let articleUrl = URL(string: model.articleImage)
        self.imageView?.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: articleUrl)
        
    }
    
}
