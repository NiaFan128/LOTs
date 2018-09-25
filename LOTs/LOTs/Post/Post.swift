//
//  Post.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/21.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Foundation

class Article {
    
    var articleTitle: String
    var articleImage: String?
    var createdTime: String
    var locationArea: String
    var cuisine: String
    var content: String
    var instagramPost: Bool?
 
    init(dictionary: [String: AnyObject]) {
        
        self.articleTitle = dictionary["articleTitle"] as? String ?? ""
        self.articleImage = dictionary["articleImage"] as? String ?? ""
        self.createdTime = dictionary["createdTime"] as? String ?? ""
        self.locationArea = dictionary["locationArea"] as? String ?? ""
        self.cuisine = dictionary["cuisine"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        
    }
}
