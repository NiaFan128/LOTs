//
//  ArticleManager.swift
//  LOTs
//
//  Created by 乃方 on 2018/12/4.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Foundation

protocol MainManagerProtocol {
    
    func getData(completion: @escaping (Article) -> Void)
    
}

protocol InspireManagerProtocol {
    
    func updateData(cuisine: String, completion: @escaping (Article) -> Void)
    
}

struct ArticleManager {
    
    let firebaseManager = FirebaseManager()
    
}

extension ArticleManager: MainManagerProtocol {
    
    func getData(completion: @escaping (Article) -> Void) {
        
        firebaseManager.getQueryOrder(path: "posts", order: "createdTime", event: .childAdded, success: { (data) in
            
            guard let articleData = data as? Article else { return }
            
            if let blockUsers = UserDefaults.standard.array(forKey: "block") {
                
                for blockUser in blockUsers {
                    
                    let block = blockUser as! String
                    
                    if block == articleData.user.uid {
                        return
                    }
                    
                }
                
            }
            
            completion(articleData)
            
            }, failure: { _ in
//                [weak self] error in
                
                //                guard let strongSelf = self else { return }
                //
                //                self?.delegate?.didFail(strongSelf, error: error)
        })
        
    }
    
}

extension ArticleManager: InspireManagerProtocol {
    
    func updateData(cuisine: String, completion: @escaping (Article) -> Void) {
        
        firebaseManager.getQueryOrderEqual(path: "posts", order: "cuisine", equalTo: cuisine, event: .valueChange, success: { (data) in
            
            guard let articleData = data as? Article else { return }
            
            if let blockUsers = UserDefaults.standard.array(forKey: "block") {
                
                for blockUser in blockUsers {
                    
                    let block = blockUser as! String
                    
                    if block == articleData.user.uid {
                        return
                    }
                    
                }
                
            }
            
            completion(articleData)
            
            }, failure: { _ in
                
                
        })
        
    }
    
}
