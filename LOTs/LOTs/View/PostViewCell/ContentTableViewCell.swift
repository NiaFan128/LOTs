//
//  ContentTableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        contentTextView.backgroundBorder()
        
        titleTextField.keyboardType = .default
        titleTextField.returnKeyType = .done

    }
    
    func titleChange(_ articleTitle: String?) {
        
        titleTextField.text = articleTitle
        
    }
    
    func contentChange(_ content: String?) {
        
        contentTextView.text = content
        
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
}
