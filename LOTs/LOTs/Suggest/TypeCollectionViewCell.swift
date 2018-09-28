//
//  TypeCollectionViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/27.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        typeImage.layer.cornerRadius = 8

        titleShadow(typeLabel)

    }

    func titleShadow(_ x: UILabel) {
        
        x.layer.shadowColor = UIColor.black.cgColor
        x.layer.shadowRadius = 6.0
        x.layer.shadowOpacity = 1.0
        x.layer.shadowOffset = CGSize.zero
        x.layer.masksToBounds = false
    }
}
