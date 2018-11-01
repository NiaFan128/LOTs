//
//  UserViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/10/15.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FBSDKLoginKit
import KeychainSwift

class UserViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var userIconImage: UIImageView!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var loginFacebookButton: UIButton!

    var ref: DatabaseReference!
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        ref = Database.database().reference()

        backgroundView.layer.cornerRadius = 20
        
        userIconImage.image = userIconImage.image?.withRenderingMode(.alwaysTemplate)
        userIconImage.tintColor = #colorLiteral(red: 0.8274509804, green: 0.3529411765, blue: 0.4, alpha: 1)
        
        loginFacebookButton.shadowRadius()
        
    }
    
    @IBAction func loginFacebook(_ sender: Any) {
    
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            if let error = error {
                
                print("Failed to login: \(String(describing: error.localizedDescription))")
                return
                
            }
            
            guard let result = result else { return }
            
            if result.isCancelled {
                
                return
                
            } else {
                
                // login successful status
                
                if let fbAccessToken = result.token.tokenString {
                    
                    self.getUserInfo(token: fbAccessToken)
                    
                }
                
            }
            
        }
    
    }
    
    func getUserInfo(token: String) {
        
        FBSDKGraphRequest(graphPath: "me",
                          parameters: ["fields" : "name, email, picture.width(400).height(400)"])?.start(completionHandler: { (connection, result, error) in
                            
                            if error == nil {
                                
                                if let info = result as? [String: Any] {
                                                                        
                                    let fbName = info["name"] as? String
                                    let fbEmail = info["email"] as? String
                                    let fbPhoto = info["picture"] as? [String: Any]
                                    let photoData = fbPhoto?["data"] as? [String: Any]
                                    let photoURL = photoData?["url"] as? String
                                    
                                    self.keychain.set(token, forKey: "token")
                                    
                                    let credential = FacebookAuthProvider.credential(withAccessToken: token)
                                    
                                    Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                                        
                                        // Successfully Authenticated User
                                        guard let uid = Auth.auth().currentUser?.uid else { return }
                                        
                                        guard let name = fbName,
                                            let email = fbEmail,
                                            let profileImageUrl = photoURL else {
                                                return
                                        }
                                        
                                        // Keychain Set Up
                                        guard self.keychain.set(uid, forKey: "uid") else { return }
                                        guard self.keychain.set(name, forKey: "name") else { return }
                                        guard self.keychain.set(profileImageUrl, forKey: "imageUrl") else { return }
                                        
                                        self.ref.child("users").child(uid).updateChildValues(["uid": uid,
                                                                                              "name": name,
                                                                                              "email": email,
                                                                                              "profileImageUrl": profileImageUrl])
                                        
                                        // Switch the page
                                        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") {
                                            
                                            UIApplication.shared.keyWindow?.rootViewController = viewController
                                            self.dismiss(animated: true, completion: nil)
                                            
                                        }
                                        
                                    })
                                    
                                }
                                
                            }
                            
                          })
        
    }

}
