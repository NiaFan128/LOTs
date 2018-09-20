//
//  LocationModelPicker.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

//class LocationModelPicker: UIPickerView {
//
//    var locationData = ["信義區",
//                        "大安區",
//                        "中山區",
//                        "松山區"]
//    
//    let customWidth: CGFloat = 100
//    let customHeight: CGFloat = 20
//
//}
//
//extension LocationModelPicker: UIPickerViewDataSource {
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//       
//        return 1
//    
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//    
//        return locationData.count
//    
//    }
//    
//}
//
//extension LocationModelPicker: UIPickerViewDelegate {
//    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        
//        return customHeight
//        
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: customWidth, height: customHeight))
//        
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: customWidth, height: 20))
//        
//        label.text = locationData[row]
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
//        view.addSubview(label)
//        
//        return view
//        
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        
//        return locationData[row]
//        
//    }
//    
//}
