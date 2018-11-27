//
//  ProfileCellModel.swift
//  LOTs
//
//  Created by 乃方 on 2018/11/27.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Foundation

struct ProfileCellModel {
    
    let postAmount: String
    let profileImageUrl: URL?
    let userName: String
//    let articleImageUrl: URL?
    
    init (name: String, image: String, posts: String) {
        
        self.profileImageUrl = URL(string: image)
//        self.articleImageUrl = URL(string: model.articleImage)
        self.userName = name
        self.postAmount = posts
        
    }
    
}
