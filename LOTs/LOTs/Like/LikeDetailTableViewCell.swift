//
//  LikeDetailTableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class LikeDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        articleImage.layer.cornerRadius = 8
        articleImage.layer.masksToBounds = true
        
        authorImage.layer.cornerRadius = 17.5
        authorImage.layer.borderColor = UIColor.white.cgColor
        authorImage.layer.borderWidth = 1

        titleShadow(authorLabel)
        titleShadow(articleTitleLabel)
        titleShadow(cuisineLabel)
        
    }
    
    func titleShadow(_ x: UILabel) {
        
        x.layer.shadowColor = UIColor.black.cgColor
        x.layer.shadowRadius = 5.0
        x.layer.shadowOpacity = 1.0
        x.layer.shadowOffset = CGSize.zero
        x.layer.masksToBounds = false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
