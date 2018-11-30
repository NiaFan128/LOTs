//
//  DiscoverCellModel.swift
//  LOTs
//
//  Created by 乃方 on 2018/11/30.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Foundation

struct  DiscoverCellModel {

    let typeImageUrl: URL?
    let cuisineTitle: String
//    let articleImageUrl: URL?
    
    init (_ model: Cuisine) {
        
        self.typeImageUrl = URL(string: model.image)
        self.cuisineTitle = model.name
//        self.articleImageUrl = URL(string: article.articleImage)
        
    }
    
}
