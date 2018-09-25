//
//  NavigationController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationBar.barTintColor = UIColor.init(red: 211.0/255.0, green: 90.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        navigationBar.tintColor = UIColor.white
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.tintColor = UIColor(red: 218.0/255.0, green: 217.0/255.0, blue: 219.0/255.0, alpha: 1.0)
        
    }


}
