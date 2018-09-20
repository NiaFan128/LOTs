//
//  PostTableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var locationPickerView: UIPickerView!
    @IBOutlet weak var cuisinePickerView: UIPickerView!
    
    let location = ["信義區", "大安區", "中山區", "松山區", "南港區", "內湖區", "中正區"]
    let cuisine = ["日式料理", "中式料理", "韓式料理", "美式料理"]
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.infoBackgroundSet()
        
        authorImage.layer.cornerRadius = 17.5
        
        locationPickerView.delegate = self
        locationPickerView.dataSource = self
        
        cuisinePickerView.dataSource = self
        cuisinePickerView.delegate = self

    }

    func infoBackgroundSet() {
    
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOffset = CGSize.zero
        infoView.layer.shadowRadius = 15
        infoView.layer.shadowOpacity = 1
        infoView.layer.shouldRasterize = true
        infoView.layer.cornerRadius = 10
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
}

extension PostTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {


    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1

    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if pickerView.tag == 0 {

            return location.count

        } else {

            return cuisine.count

        }

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView.tag == 0 {

            return location[row]

        } else {

            return cuisine[row]

        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        pickerView.reloadAllComponents()

    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        let color = (row == pickerView.selectedRow(inComponent: component)) ? UIColor(red: 208.0/255.0, green: 42.0/255.0, blue: 62.0/255.0, alpha: 1.0) : UIColor.lightGray
        
        if pickerView.tag == 0 {
            
            return NSAttributedString(string: location[row],
                                      attributes: [NSAttributedString.Key.foregroundColor: color])
            
        } else {
            
            return NSAttributedString(string: cuisine[row],
                                      attributes: [NSAttributedString.Key.foregroundColor: color])
            
        }

//        return NSAttributedString(string: location[row],
//                                attributes: [NSAttributedString.Key.foregroundColor: color])

    }

    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//
//        let pickerLabel = UILabel()
//
//        pickerLabel.text = location[row]
//        pickerLabel.textAlignment = .center
//        pickerLabel.font = UIFont(name: "Helvetica Neue", size: 14.0)
////        pickerLabel.textColor = UIColor(red: 208.0/255.0, green: 42.0/255.0, blue: 62.0/255.0, alpha: 1.0)
//
//        return pickerLabel
//
//    }

}
