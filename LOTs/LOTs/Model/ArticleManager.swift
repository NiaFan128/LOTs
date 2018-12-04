//
//  ArticleManager.swift
//  LOTs
//
//  Created by 乃方 on 2018/12/4.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Foundation
import KeychainSwift

protocol MainManagerProtocol {
    
    func getData(completion: @escaping (Article) -> Void)
    
}

protocol InspireManagerProtocol {
    
    func updateData(cuisine: String, completion: @escaping (Article) -> Void)
    
}

protocol LikeManagerProtocol {
    
    func readLocation(completion: @escaping (Location) -> Void)
//    func readLikeArticle(location: String, completion: @escaping (String) -> Void)
    func readLikeArticleData(aritcleID: String, completion: @escaping (Article) -> Void)
    
}

protocol ProfileManagerProtocol {
    
    func getUserData(uid: String, completion: @escaping (Article) -> Void)
    
}

struct ArticleManager {
    
    var uid: String
    let keychain = KeychainSwift()
    let firebaseManager = FirebaseManager()

    init() {
        
        uid = keychain.get("uid") ?? ""
        
    }
    
    func blockUser(uid: String) -> Bool {
        
        if let blockUsers = UserDefaults.standard.array(forKey: "block") {
            
            for blockUser in blockUsers {
                
                let block = blockUser as! String
                
                if block == uid {

                    return true

                }
                
            }
            
        }
        
        return false
    }
    
}

extension ArticleManager: MainManagerProtocol {
    
    func getData(completion: @escaping (Article) -> Void) {
        
        firebaseManager.getQueryOrder(path: "posts", order: "createdTime", event: .childAdded, success: { (data) in
            
            guard let articleData = data as? Article else { return }
            
            if self.blockUser(uid: articleData.user.uid) != true {
            
                completion(articleData)
                
            }
            
            }, failure: { _ in

        })
        
    }
    
}

extension ArticleManager: InspireManagerProtocol {
    
    func updateData(cuisine: String, completion: @escaping (Article) -> Void) {
        
        firebaseManager.getQueryOrderEqual(path: "posts", order: "cuisine", equalTo: cuisine, event: .valueChange, success: { (data) in
            
            guard let articleData = data as? Article else { return }
            
            if self.blockUser(uid: articleData.user.uid) != true {
            
                completion(articleData)
            
            }
            
            }, failure: { _ in
                
                
        })
        
    }
    
}

extension ArticleManager: LikeManagerProtocol {

    func readLocation(completion: @escaping (Location) -> Void) {
        
        firebaseManager.getLocation(path: "locations",
                                    event: .childAdded,
                                    success: { (data) in
                                        
            guard let locationData = data as? Location else { return }
                                        
            completion(locationData)
                                        
        }, failure: {(_) in
         
            
        })
        
    }
    
    func readLikeArticleData(aritcleID: String, completion: @escaping (Article) -> Void) {
        
        firebaseManager.getQueryBySingle(path: "posts",
                                         toValue: aritcleID,
                                         event: .valueChange,
                                         success: { (data) in
                                            
            guard let articleData = data as? Article else { return }
                                            
            if self.blockUser(uid: articleData.user.uid) != true {
                                                
                completion(articleData)
                                                
            }
                                            
        }, failure: { _ in
            
        })
        
    }
    
}

extension ArticleManager: ProfileManagerProtocol {
    
    func getUserData(uid: String, completion: @escaping (Article) -> Void) {
        
        firebaseManager.getQueryOrderEqual(path: "posts",
                                           order: "user/uid",
                                           equalTo: uid,
                                           event: .valueChange,
                                           success: { (data) in
                                            
            guard let articleData = data as? Article else { return }

            completion(articleData)
                                            
        },failure: { _ in
                                            
        })
        
    }
    
}
