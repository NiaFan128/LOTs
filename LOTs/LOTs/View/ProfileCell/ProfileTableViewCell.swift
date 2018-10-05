//
//  ProfileTableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var postsAmountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        profileImage.roundCorner()
        editButton.layer.cornerRadius = 6
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.layer.borderWidth = 1

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
