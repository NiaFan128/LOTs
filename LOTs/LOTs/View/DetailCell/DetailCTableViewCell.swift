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
    @IBOutlet weak var heightOfTextView: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentTextView.backgroundColor = UIColor.clear
        contentTextView.isScrollEnabled = false
        contentTextView.sizeToFit()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutIfNeeded() {
        
//        let sizeForTextView = contentTextView.sizeThatFits(contentTextView.frame.size)
//        let height = sizeForTextView.height
//        print(contentTextView.frame.height)
//        heightOfTextView.constant = height
        
    }
    
}
