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
    @IBOutlet weak var contentCancelButton: UIButton!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        contentTextView.backgroundBord()
        
        titleTextField.keyboardType = .default
        titleTextField.returnKeyType = .done

    }
    
    func titleChange(_ articleTitle: String?) {
        
        titleTextField.text = articleTitle
        
    }
    
    func contentChange(_ content: String?) {
        
        contentTextView.text = content
        
    }

    @objc func onClearPressed(_ sender: Any) {
        
        contentTextView.text = ""
        contentCancelButton.isEnabled = false
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        
        titleTextField.text = ""
        contentTextView.text = ""
        
    }
    
}
