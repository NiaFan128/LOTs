//
//  LikeCollectionViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class LikeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var articleImage: UIImageView!
    
    override func awakeFromNib() {

        super.awakeFromNib()
        
        articleImage.layer.cornerRadius = 6

        areaLabel.layer.shadowColor = UIColor.gray.cgColor
        areaLabel.layer.shadowRadius = 3.0
        areaLabel.layer.shadowOpacity = 1.0
        areaLabel.layer.shadowOffset = CGSize.zero
        areaLabel.layer.masksToBounds = false

    }

}
