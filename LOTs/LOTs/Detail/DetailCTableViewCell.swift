//
//  DetailCTableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/27.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class DetailCTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentTextView.backgroundColor = UIColor.clear
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
