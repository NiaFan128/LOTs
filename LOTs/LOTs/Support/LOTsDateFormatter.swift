//
//  LOTsDateFormatter.swift
//  LOTs
//
//  Created by 乃方 on 2018/11/27.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Foundation

struct LOTsDateFormatter {
    
    let dateFormatter: DateFormatter
    
    init(dateFormat: String = "MMMM / dd / yyyy") {
        
        self.dateFormatter = DateFormatter()
        
        self.dateFormatter.dateFormat = dateFormat
        
    }
    
    func dateWithUnitTime(time: Int) -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        
        return dateFormatter.string(from: date)
        
    }
    
}
