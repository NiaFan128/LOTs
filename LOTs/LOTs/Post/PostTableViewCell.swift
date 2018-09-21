//
//  PostTableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import iOSDropDown

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var locationTextField: DropDown!
    @IBOutlet weak var cuisineTextField: DropDown!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.infoBackgroundSet()
        self.locationPick()
        self.cuisinePick()
        
        locationTextField.target(forAction: #selector(locationTextField.showList), withSender: self)
        
//        authorImage.layer.cornerRadius = 17.5
        

    }

    func infoBackgroundSet() {
    
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOffset = CGSize.zero
        infoView.layer.shadowRadius = 15
        infoView.layer.shadowOpacity = 1
        infoView.layer.shouldRasterize = true
        infoView.layer.cornerRadius = 10
        
    }
    
    func locationPick() {
        
        locationTextField.selectedRowColor = .white

        locationTextField.optionArray = ["大安區", "信義區", "中山區", "內湖區"]
        locationTextField.optionIds = [1, 23, 54, 22]
        
        locationTextField.didSelect { (selectedText, index, id) in
            
            self.locationTextField.text = "\(selectedText)"
            self.locationTextField.textColor = UIColor(red: 188.0/255.0, green: 0.0/255.0, blue: 25.0/255.0, alpha: 1.0)
            
            //            "Selected String: \(selectedText) \n index: \(index)"
            
        }
        
    }
    
    func cuisinePick() {
        
        cuisineTextField.selectedRowColor = .white
        
        cuisineTextField.optionArray = ["中式料理", "日式料理", "韓式料理", "美式料理"]
        cuisineTextField.optionIds = [1, 23, 54, 22]
        
        cuisineTextField.didSelect { (selectedText, index, id) in
            
            self.cuisineTextField.text = "\(selectedText)"
            self.cuisineTextField.textColor = UIColor(red: 188.0/255.0, green: 0.0/255.0, blue: 25.0/255.0, alpha: 1.0)
            
            //            "Selected String: \(selectedText) \n index: \(index)"
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
}
