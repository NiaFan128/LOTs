//
//  LoginViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/25.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var guestModeButton: UIButton!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var googleImage: UIImageView!
    
    let photoSize: String = "?width=400&height=400"

//    let userId = UserManager.shared.getUserId()
//    let userName = UserManager.shared.getUserName()
//    let userEmail = UserManager.shared.getUserEmail()
//    let userProfile = UserManager.shared.getUserProfileImage()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        facebookLoginButton.corner(corner: 7)
        guestModeButton.corner(corner: 7)
        
        googleLoginButton.isHidden = true
        googleImage.isHidden = true
        
        facebookImage.image = facebookImage.image?.withRenderingMode(.alwaysTemplate)
        facebookImage.tintColor = UIColor.init(red: 250.0/255.0, green: 145.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        
//        googleImage.image = googleImage.image?.withRenderingMode(.alwaysTemplate)
//        googleImage.tintColor = UIColor.init(red: 250.0/255.0, green: 145.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            guard error == nil else {
                print("Failed to login: \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard result != nil else {
                print(result.debugDescription)
                return
            }
            
            guard let fbAccessToken = result?.token.tokenString else {
                print("Failed to get access token")
                return
            }
            
//            print("ID:\(String(describing: result?.token.appID)), Token:\(String(describing: accessToken))")
            
            // Firebase Auth Login Set up
            let credential = FacebookAuthProvider.credential(withAccessToken: fbAccessToken)
            
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                
                // Error Handler
                if let error = error {
                    
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                // Successfully Authenticated User
                guard let currentUser = Auth.auth().currentUser, let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                
                guard let name = currentUser.displayName,
                    let email = currentUser.email,
                    let profileImageUrl = currentUser.photoURL?.absoluteString else {
                    return
                }
                
                // Save the User Default
                UserDefaults.standard.set(profileImageUrl + self.photoSize, forKey: "userProfile")
                UserDefaults.standard.set(name, forKey: "userName")
                UserDefaults.standard.set(email, forKey: "userEmail")
                UserDefaults.standard.set(uid, forKey: "userId")
                
                let values = ["uid": uid,
                              "name": name,
                              "email": email,
                              "profileImageUrl": profileImageUrl + self.photoSize] as [String: AnyObject]
                
                let ref = Database.database().reference()
                
                let usersReference = ref.child("users").child(uid)
                
                usersReference.updateChildValues(values)
                
                // Switch the page
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") {
                    
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            })
            
        }
        
    }
        
}

//                if let currentUser = Auth.auth().currentUser {
//
//                    self.user.name = currentUser.displayName
//                    self.user.email = currentUser.email
//                    self.user.profileImageUrl = String(currentUser.photoURL?.absoluteString ?? "") + self.photoSize
////
//                }

//                print(Auth.auth().currentUser?.displayName)
//                print(String(Auth.auth().currentUser?.photoURL?.absoluteString ?? "") + self.photoSize)
