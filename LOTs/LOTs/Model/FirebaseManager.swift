//
//  FirebaseManager.swift
//  LOTs
//
//  Created by 乃方 on 2018/11/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import Firebase
import Foundation

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

class FirebaseManager {
    
    var ref: DatabaseReference!
    
    private let provider = ArticleProvider()
    private let decoder = JSONDecoder()
    
    init() {
        ref = Database.database().reference()
    }
    
    // no query
    func getNoQuery(
        path: String,
        event: FirebaseEventType,
        success: @escaping (Any) -> Void,
        failure: @escaping (Error) -> Void
        ) {
        
        ref.child(path).observeSingleEvent(of: event.eventType(), with: { snapshot in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: value) else { return }
            
            do {
                
                let articleData = try self.decoder.decode(Article.self, from: jsonData)
                
                success(articleData)
                
            } catch {
                
                print(error)
                failure(error)
                
            }
            
        })
        
    }
    
    func getLocation(
        path: String,
        event: FirebaseEventType,
        success: @escaping (Any) -> Void,
        failure: @escaping (Error) -> Void
        ) {
        
        ref.child(path).observe(event.eventType(), with: { snapshot in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: value) else { return }
            
            do {
                
                let locationData = try self.decoder.decode(Location.self, from: jsonData)
                
                success(locationData)
                
            } catch {
                
                print(error)
                failure(error)
                
            }
            
        })
        
    }
    
    // Get query
    func getQueryOrder(
        path: String,
        order: String,
        event: FirebaseEventType,
        success: @escaping (Any) -> Void,
        failure: @escaping (Error) -> Void
        ) {
        
        ref.child(path).queryOrdered(byChild: order).observe(event.eventType(), with: { snapshot in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: value) else { return }
            
            do {
                
                let articleData = try self.decoder.decode(Article.self, from: jsonData)
                
                success(articleData)
                
            } catch {
                
                print(error)
                failure(error)
                
            }
            
        })
        
    }
    
    func getQueryOrderEqual(
        path: String,
        order: String,
        equalTo: Any,
        event: FirebaseEventType,
        success: @escaping (Any) -> Void,
        failure: @escaping (Error) -> Void
        ) {
        
        ref.child(path).queryOrdered(byChild: order).queryEqual(toValue: equalTo).observeSingleEvent(of: event.eventType(), with: { snapshot in
            
            guard let dictionary = snapshot.value as? NSDictionary else { return }
            
            for value in dictionary.allValues {
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: value) else { return }
                
                do {
                    
                    let articleData = try self.decoder.decode(Article.self, from: jsonData)
                    
                    success(articleData)
                    
                } catch {
                    
                    print(error)
                    failure(error)
                    
                }
                
            }
            
        })
        
    }
    
    func getQueryByType(
        path: String,
        toValue: String,
        event: FirebaseEventType,
        success: @escaping (Any) -> Void,
        failure: @escaping (Error) -> Void
        ) {
        
        ref.child(path).queryOrderedByKey().queryEqual(toValue: toValue).observeSingleEvent(of: event.eventType(),with: { snapshot in
            
            guard let dictionary = snapshot.value as? NSDictionary else { return }
            
            for valueData in dictionary.allValues {
                
                guard let dictionarData = valueData as? NSDictionary else { return }
                
                success(dictionarData)
                
            }
            
        })
        
    }
    
    func getQueryBySingle(
        path: String,
        toValue: String,
        event: FirebaseEventType,
        success: @escaping (Any) -> Void,
        failure: @escaping (Error) -> Void
        ) {
        
        ref.child(path).queryOrderedByKey().queryEqual(toValue: toValue).observeSingleEvent(of: event.eventType(),with: { snapshot in
            
            guard let dictionary = snapshot.value as? NSDictionary else { return }
            
            for value in dictionary.allValues {
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: value) else { return }
                
                do {
                    
                    let articleData = try self.decoder.decode(Article.self, from: jsonData)
                    
                    success(articleData)
                    
                } catch {
                    
                    print(error)
                    failure(error)
                    
                }
                
            }
            
        })
        
    }
    
}
