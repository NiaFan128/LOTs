//
//  DetailCellModel.swift
//  LOTs
//
//  Created by 乃方 on 2018/11/27.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Foundation

struct DetailCellModel {
    
    private let dateFormatter = LOTsDateFormatter()
    
    let articleTitle: String
    let articleImageUrl: URL?
    let createdTimeString: String
    let location: String
    let cuisine: String
    let userName: String
    let userImageUrl: URL?
    
    init(_ model: Article) {
        
        self.articleTitle = model.articleTitle
        self.articleImageUrl = URL(string: model.articleImage)
        self.createdTimeString = dateFormatter.dateWithUnitTime(time: model.createdTime)
        self.location = model.location
        self.cuisine = model.cuisine
        self.userName = model.user.name
        self.userImageUrl = URL(string: model.user.image)
        
    }
    
}
