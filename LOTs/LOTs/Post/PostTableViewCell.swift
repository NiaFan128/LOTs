//
//  PostTableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import iOSDropDown
import DatePickerDialog

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: DropDown!
    @IBOutlet weak var cuisineTextField: DropDown!
    
    var locationCompletion: ((_ data: String) -> Void)?
    var cuisineCompletion: ((_ data: String) -> Void)?
    var dateCompletion: ((_ data: String) -> Void)?

    var selectLocation: String?
    var selectCuisine: String?
    var selectDate: String?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.infoBackgroundSet()
        self.locationPick()
        self.cuisinePick()
        self.date()
        
        locationTextField.target(forAction: #selector(locationTextField.showList), withSender: self)
        
        dateTextField.delegate = self

    }

    func date() {
        
        let now: Date = Date()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy 年 MM 月 dd 日"
        
        let dateString: String = dateFormat.string(from: now)
    
        dateTextField.text = dateString
    }
    
    func infoBackgroundSet() {
    
        infoView.layer.shadowColor = UIColor.black.cgColor
        infoView.layer.shadowOffset = CGSize.zero
        infoView.layer.shadowRadius = 15
        infoView.layer.shadowOpacity = 1
        infoView.layer.shouldRasterize = true
        infoView.layer.cornerRadius = 10
        
    }
    
    func locationPick(){
        
        
        locationTextField.selectedRowColor = .white

        locationTextField.optionArray = ["大安區", "信義區", "中山區", "內湖區"]
        locationTextField.optionIds = [1, 23, 54, 22]
        
        locationTextField.didSelect { (selectedText, index, id) in
            
            self.locationCompletion?(selectedText)
            
            self.locationTextField.text = "\(selectedText)"
            self.locationTextField.textColor = UIColor(red: 188.0/255.0, green: 0.0/255.0, blue: 25.0/255.0, alpha: 1.0)
            
        }
        
    }
    
    func cuisinePick() {
        
        cuisineTextField.selectedRowColor = .white
        
        cuisineTextField.optionArray = ["中式料理", "日式料理", "韓式料理", "美式料理"]
        cuisineTextField.optionIds = [1, 23, 54, 22]
        
        cuisineTextField.didSelect { (selectedText, index, id) in
            
            self.cuisineCompletion?(selectedText)

            self.cuisineTextField.text = "\(selectedText)"
            self.cuisineTextField.textColor = UIColor(red: 188.0/255.0, green: 0.0/255.0, blue: 25.0/255.0, alpha: 1.0)
                        
        }
        
    }
    
    func datePickerTapped() {
        
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.month = -3
        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
        
        let datePicker = DatePickerDialog(textColor: UIColor(red: 188.0/255.0, green: 0.0/255.0, blue: 25.0/255.0, alpha: 1.0),
                                          buttonColor: .lightGray,
                                          font: UIFont.boldSystemFont(ofSize: 17),
                                          showCancelButton: true)
        
        datePicker.show("Choose a Date",
                        doneButtonTitle: "Done",
                        cancelButtonTitle: "Cancel",
                        minimumDate: threeMonthAgo,
                        maximumDate: currentDate,
                        datePickerMode: .date) { (date) in
                            
                            if let date = date {
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy 年 MM 月 dd 日"
                                
                                self.selectDate = formatter.string(from: date)
                                
                                self.dateTextField.text = self.selectDate
                                self.dateCompletion?(self.selectDate ?? "")
                                
                            }
                            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
}

extension PostTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.dateTextField {
            
            datePickerTapped()
            
            return false
        }
        
        return true
    
    }
    
}
