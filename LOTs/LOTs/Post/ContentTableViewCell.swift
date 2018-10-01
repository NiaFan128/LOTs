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
    
//    fileprivate var didSelectCompletion: (String) -> () = {selectedText  in }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.contentSet()
        
//        titleTextField.keyboardType = .default
//        titleTextField.returnKeyType = .done
//        contentTextView.delegate = self

    }

    func contentSet() {
        
        contentTextView.layer.shadowColor = UIColor.black.cgColor
        contentTextView.layer.shadowOffset = CGSize.zero
        contentTextView.layer.shadowRadius = 15
        contentTextView.layer.shadowOpacity = 1
        contentTextView.layer.shouldRasterize = true
        contentTextView.layer.cornerRadius = 10
        
    }
    
    func backgroundSet() {
        
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize.zero
        backView.layer.shadowRadius = 15
        backView.layer.shadowOpacity = 1
        backView.layer.shouldRasterize = true
        backView.layer.cornerRadius = 10
        
    }

//    public func didSelect(completion: @escaping (_ selectedText: String) -> ()) {
//
//        didSelectCompletion = completion
//
//    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//
//        print(textView.text)
//
//    }
//
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
