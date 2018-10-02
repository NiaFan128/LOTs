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

    func getUserId() -> String? {
        
        guard let userId = UserDefaults.standard.string(forKey: "userId") else {
            return nil
        }
        
        return userId
        
    }
    
    func getUserName() -> String? {
        
        guard let userName = UserDefaults.standard.string(forKey: "userName") else {
            return nil
        }
        
        return userName
        
    }

    func getUserEmail() -> String? {
        
        guard let userName = UserDefaults.standard.string(forKey: "userEmail") else {
            return nil
        }
        
        return userName
        
    }
    
    func getUserProfileImage() -> String? {
        
        guard let userProfileImage = UserDefaults.standard.string(forKey: "userProfile") else {
            return nil
        }
        
        return userProfileImage
        
    }
    
    
    //    private var user: User?
    
    //    func currentUser() -> User? {
    //        return user
    //    }
}
