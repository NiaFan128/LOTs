//
//  Food.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/19.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

struct Food {
    
    var title: String
    var image: UIImage

    init(title: String, image: UIImage) {
        
        self.title = title
        self.image = image
    
    }
    
    init?(dictionary: [String: String]) {
        
        guard let title = dictionary["Title"], let photo = dictionary["Photo"], let image = UIImage(named: photo) else {
            return nil
        }
        
        self.init(title: title, image: image)
        
    }
    
    static func allFood() -> [Food] {
        
        var foods = [Food]()
        
        guard let URL = Bundle.main.url(forResource: "Food", withExtension: "plist"), let photosFromPlist = NSArray(contentsOf: URL) as? [[String: String]] else {
            
            return foods
        
        }
        
        for dictionary in photosFromPlist {
            
            if let food = Food(dictionary: dictionary) {
                
                foods.append(food)
                
            }
            
        }
        
        return foods

    }
    
}
