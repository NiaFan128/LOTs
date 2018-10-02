//
//  UserManager.swift
//  LOTs
//
//  Created by 乃方 on 2018/10/1.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class UserManager {
    
    static let shared = UserManager()
    
    private var user: User?

    func currentUser() -> User? {
        return user
    }
    
}
