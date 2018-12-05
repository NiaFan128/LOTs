//
//  MainFoodCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Kingfisher

protocol MainCellModelProtocol {
    
    var articleTitle: String { get }
    var profileImage: String { get }
    var articleImage: String { get }
    
}

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
    
    func updateCellInfo(_ model: MainCellModelProtocol) {
        
        self.titleLabel.text = model.articleTitle
    
        let url = URL(string: model.profileImage)
        self.profileImageView.kf.setImage(with: url)

        let articleUrl = URL(string: model.articleImage)
        self.imageView?.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: articleUrl)
        
    }
    
    func updateCell(title: String, imageUrl: String, profileUrl: String) {
        
        self.titleLabel.text = title
        
        let url = URL(string: profileUrl)
        self.profileImageView.kf.setImage(with: url)
        
        let articleUrl = URL(string: imageUrl)
        self.imageView?.kf.indicatorType = .activity
        self.imageView.kf.setImage(with: articleUrl)
    }
    
}
