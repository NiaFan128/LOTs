//
//  Post.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/21.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Foundation

struct Article {
    
    var articleTitle: String
    var articleImage: String
    var height: CGFloat?
    var width: CGFloat?
    var createdTime: Int?
    var location: String?
    var cuisine: String?
    var content: String?
    var user: User
    var instagramPost: Bool?

}

struct User {
    
    var name: String
    var image: String
    var uid: String
    
}

//////////////
//
//class oldArticle {
//
//    var articleTitle: String
//    var articleImage: String?
//    var height: CGFloat
//    var width: CGFloat
//    var createdTime: Int
//    var location: String
//    var cuisine: String
//    var content: String
//    var userImage: String
//    var userName: String
//    var instagramPost: Bool?
//
//    init(dictionary: [String: AnyObject]) {
//
//        self.articleTitle = dictionary["articleTitle"] as? String ?? ""
//        self.articleImage = dictionary["articleImage"] as? String ?? ""
//        self.height = dictionary["height"] as? CGFloat ?? 0
//        self.width = dictionary["width"] as? CGFloat ?? 0
//        self.createdTime = dictionary["createdTime"] as? Int ?? 0
//        self.location = dictionary["location"] as? String ?? ""
//        self.cuisine = dictionary["cuisine"] as? String ?? ""
//        self.content = dictionary["content"] as? String ?? ""
//
//        let user = dictionary["user"] as? [String: AnyObject] ?? ["": AnyObject.self as AnyObject]
//        self.userName = user["name"] as? String ?? ""
//        self.userImage = user["image"] as? String ?? ""
//
//    }
//}
