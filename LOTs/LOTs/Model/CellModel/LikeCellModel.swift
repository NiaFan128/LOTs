//
//  LikeCellModel.swift
//  LOTs
//
//  Created by 乃方 on 2018/11/27.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Foundation

struct LikeCellModel {

    let userImageUrl: URL?
    let userName: String
    let articleImageUrl: URL?
    let articleTitle: String
    let cuisine: String
    
    init (_ model: Article) {
        
        self.userImageUrl = URL(string: model.user.image)
        self.userName = model.user.name
        self.articleImageUrl = URL(string: model.articleImage)
        self.articleTitle = model.articleTitle
        self.cuisine = model.cuisine
        
    }
    
}
