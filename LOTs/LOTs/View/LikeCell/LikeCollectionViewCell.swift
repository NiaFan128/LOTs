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
        
        articleImage.corner()
        areaLabel.titleShadow()

    }
    
    func updateCellInfo(area: String, image: String) {
        
        areaLabel.text = area
        articleImage.kf.setImage(with: URL(string: image))
        
    }

}
