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
        
        articleImage.corner(corner: 8)
        authorImage.cornerBorder()
        authorLabel.titleShadow()
        articleTitleLabel.titleShadow()
        cuisineLabel.titleShadow()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
