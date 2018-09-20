//
//  ContentTableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.backgroundSet()

    }

    func backgroundSet() {
        
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize.zero
        backView.layer.shadowRadius = 15
        backView.layer.shadowOpacity = 1
        backView.layer.shouldRasterize = true
        backView.layer.cornerRadius = 10
        
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
