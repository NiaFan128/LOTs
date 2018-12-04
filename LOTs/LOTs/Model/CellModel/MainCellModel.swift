//
//  MainCellModel.swift
//  LOTs
//
//  Created by 乃方 on 2018/11/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Foundation

struct MainCellModel: MainCellModelProtocol {
    
    let articleTitle: String
    let profileImage: String
    let articleImage: String

    init(model: Article) {
        
        self.articleTitle = model.articleTitle
        self.profileImage = model.user.image
        self.articleImage = model.articleImage
        
    }
    
}

