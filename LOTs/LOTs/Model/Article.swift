//
//  Post.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/21.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Foundation

struct Article: Codable {
    
    var articleID: String
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
    var interestedIn: Bool = false

}

struct User: Codable {
    
    var name: String
    var image: String
    var uid: String
    
}
