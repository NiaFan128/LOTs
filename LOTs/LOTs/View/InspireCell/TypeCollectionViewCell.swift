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
    @IBOutlet weak var underlineView: UIView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    
        typeImage.corner()
        typeLabel.titleShadow()
        
    }
    
}
