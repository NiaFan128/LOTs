//
//  HistoryLayout.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/28.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class HistoryLayout: UICollectionViewLayout {
    
    var delegate: HistoryLayout?
    
    var yOffSet: CGFloat = 0
    var xOffSetLand: CGFloat = 0
    var xOffSetPort: CGFloat = 0
    
    var portraitElements: [Int] = []
    
    var portraintItemPositionIndex = PortraintItemPositionIndex.Left
    
}
