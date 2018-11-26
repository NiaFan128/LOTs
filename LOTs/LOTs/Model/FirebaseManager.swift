//
//  FirebaseManager.swift
//  LOTs
//
//  Created by 乃方 on 2018/11/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Firebase
import Foundation

class FirebaseManager {
    
    var ref: DatabaseReference!
    
    private let provider = ArticleProvider()
    
    private let decoder = JSONDecoder()
    
    init() {
        ref = Database.database().reference()
    }
    
    func getNoQuery(
        path: String,
        event: FirebaseEventType,
        success: @escaping (Any) -> Void,
        failure: @escaping (Error) -> Void
        ) {
        
        ref.child(path).observeSingleEvent(of: event.eventType()) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            guard let articleJSONData = try? JSONSerialization.data(withJSONObject: value) else { return }

            do {
                
                let articleData = try self.decoder.decode(Article.self, from: articleJSONData)
                

                
            } catch {
                
                
                
            }
            
            
        }
        
    }
    
    
}

enum FirebaseEventType {
    
    case valueChange
    case childAdded
    
    func eventType() -> DataEventType {
        
        switch self {
            
        case .valueChange:
            return .value
            
        case .childAdded:
            return .childAdded
        }
        
    }
}
