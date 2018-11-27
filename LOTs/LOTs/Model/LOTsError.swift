//
//  LOTsError.swift
//  LOTs
//
//  Created by 乃方 on 2018/11/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Foundation

enum LOTsError: String, Error {
    
    case loginFacebookFail = "Login with facebook fail."
    
    case loginFacebookReject = "Please permit the facebook login as Voyage login."
    
    case serverError = "Serve error"
    
}
