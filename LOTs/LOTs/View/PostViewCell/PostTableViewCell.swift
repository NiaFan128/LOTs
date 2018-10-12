//
//  PostTableViewCell.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import McPicker
import DatePickerDialog

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: McTextField!
    @IBOutlet weak var cuisineTextField: McTextField!
    @IBOutlet weak var instagramSwitchButton: UIButton!
    @IBOutlet weak var cityTextField: UITextField!
    
    var locationCompletion: ((_ data: String) -> Void)?
    var cuisineCompletion: ((_ data: String) -> Void)?
    var dateCompletion: ((_ data: Int) -> Void)?

    var selectLocation: String?
    var selectCuisine: String?
    var selectDate: String?
    
    var upload = true
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
//        infoView.backgroundBorder()
        infoView.backgroundBord()
        
        self.locationPicker()
        self.cuisinePicker()
        self.date()
                
        cityTextField.isUserInteractionEnabled = false

//        dateTextField.contentScaleFactor = UIScreen.main.scale
//        cuisineTextField.contentScaleFactor = UIScreen.main.scale
//        locationTextField.contentScaleFactor = UIScreen.main.scale
        
        print(self.frame.height)
        
        dateTextField.delegate = self

    }

    func date() {
        
        let now: Date = Date()
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "MMMM / dd / yyyy"
        
        let dateString: String = dateFormat.string(from: now)
    
        dateTextField.text = dateString
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
                                print(date)
                                let dateFormat: DateFormatter = DateFormatter()
                                dateFormat.dateFormat = "MMMM / dd / yyyy"
                                self.selectDate = dateFormat.string(from: date)
                                self.dateTextField.text = self.selectDate
                                self.dateCompletion?(Int(date.timeIntervalSince1970))
                                
                            }
                            
        }
        
    }
    
    func locationChange(_ location: String?) {
        
        locationTextField.text = location
        
    }
    
    func cuisineChange(_ cuisine: String?) {
        
        cuisineTextField.text = cuisine
        
    }
    
    func dateChange(_ createdTime: Int?) {
        
        let timeData = NSDate(timeIntervalSince1970: TimeInterval(createdTime ?? 0))
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "MMMM / dd / yyyy"
        let stringDate = dateFormat.string(from: timeData as Date)
        dateTextField.text = stringDate
        
    }
    
    func locationPicker() {
        
        let data: [[String]] = [
            ["中正區", "大同區", "中山區", "松山區", "大安區", "萬華區",
             "信義區", "士林區", "北投區", "內湖區", "南港區", "文山區"]
        ]
        
        let locationInputView = McPicker(data: data)
        
        // 彈跳起來的上方背景色
        locationInputView.backgroundColor = .gray
        locationInputView.backgroundColorAlpha = 0.25
        locationTextField.inputViewMcPicker = locationInputView
        
        locationTextField.doneHandler = { [weak locationTextField] (selections) in
            
            self.selectLocation = selections[0]!
            
            locationTextField?.text = self.selectLocation
            locationTextField?.textColor = UIColor(red: 211.0/255.0, green: 90.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            self.locationCompletion?(self.selectLocation ?? "")
            
        }
        
        locationTextField.selectionChangedHandler = { [weak locationTextField] (selections, componentThatChanged) in
            
            locationTextField?.text = selections[componentThatChanged]!
            
        }
        
        locationTextField.cancelHandler = { [weak locationTextField] in
            
            locationTextField?.text = "Cancelled."
            
        }
        
        locationTextField.textFieldWillBeginEditingHandler = { [weak locationTextField] (selections) in
            
            if locationTextField?.text == "" {
                // Selections always default to the first value per component
                locationTextField?.text = selections[0]
                
            }
            
        }

    }
    
    func cuisinePicker(){
        
        let data: [[String]] = [
            ["台式料理","日式料理", "中式料理","義式料理", "韓式料理", "西式料理","美式料理", "泰式料理"]
        ]
        
        let mcInputView = McPicker(data: data)
        
        // 彈跳起來的上方背景色
        mcInputView.backgroundColor = .gray
        mcInputView.backgroundColorAlpha = 0.25
        cuisineTextField.inputViewMcPicker = mcInputView
        
        cuisineTextField.doneHandler = { [weak cuisineTextField] (selections) in
            
            self.selectCuisine = selections[0]!
            
            cuisineTextField?.text = self.selectCuisine
            cuisineTextField?.textColor = UIColor(red: 211.0/255.0, green: 90.0/255.0, blue: 102.0/255.0, alpha: 1.0)

            self.cuisineCompletion?(self.selectCuisine ?? "")

        }
        
        cuisineTextField.selectionChangedHandler = { [weak cuisineTextField] (selections, componentThatChanged) in

            cuisineTextField?.text = selections[componentThatChanged]!

        }

        cuisineTextField.cancelHandler = { [weak cuisineTextField] in
            
            cuisineTextField?.text = "Cancelled."
        
        }
        
        cuisineTextField.textFieldWillBeginEditingHandler = { [weak cuisineTextField] (selections) in
            
            if cuisineTextField?.text == "" {
                // Selections always default to the first value per component
                cuisineTextField?.text = selections[0]
            
            }
            
        }
        
    }
    
    @IBAction func facebookSelect(_ sender: Any) {
        
        let switchOn = !upload
        upload = switchOn
        
        if upload {
            
            instagramSwitchButton.setImage(#imageLiteral(resourceName: "switch_off").withRenderingMode(.alwaysTemplate), for: .normal)
            //            instagramSwitchButton.tintColor = UIColor.lightGray
            
        } else {
            
            instagramSwitchButton.setImage(#imageLiteral(resourceName: "switch_on").withRenderingMode(.alwaysTemplate), for: .normal)
            instagramSwitchButton.tintColor = UIColor.init(red: 211.0/255.0, green: 90.0/255.0, blue: 102.0/255.0, alpha: 1.0)
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)

    }
    
    override func prepareForReuse() {
        
        date()
        locationTextField.text = "地區"
        locationTextField.textColor = #colorLiteral(red: 0.5217987895, green: 0.5218115449, blue: 0.52180475, alpha: 1)
        cuisineTextField.text = "料理種類"
        cuisineTextField.textColor = #colorLiteral(red: 0.5217987895, green: 0.5218115449, blue: 0.52180475, alpha: 1)
        
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
