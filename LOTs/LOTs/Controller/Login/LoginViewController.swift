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
import KeychainSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var guestModeButton: UIButton!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var googleImage: UIImageView!
    @IBOutlet weak var facebookWarningLabel: UILabel!
    @IBOutlet weak var termsOfServiceLabel: UILabel!
    
    var ref: DatabaseReference!
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        facebookLoginButton.corner(corner: 7)
        guestModeButton.corner(corner: 7)
        
        googleLoginButton.isHidden = true
        googleImage.isHidden = true
        
        termsOfServiceLabel.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(facebookEULA))
        termsOfServiceLabel.addGestureRecognizer(gesture)
        
        ref = Database.database().reference()
        
        facebookImage.image = facebookImage.image?.withRenderingMode(.alwaysTemplate)
        facebookImage.tintColor = UIColor.init(red: 250.0/255.0, green: 145.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        
//        googleImage.image = googleImage.image?.withRenderingMode(.alwaysTemplate)
//        googleImage.tintColor = UIColor.init(red: 250.0/255.0, green: 145.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        
    }
    
    // Facebook Login
    @IBAction func facebookLogin(_ sender: Any) {
        
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
                        
                        print("info: \(info)")
                        
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
    
    // Visitor Mode
    @IBAction func visitorLogin(_ sender: Any) {
        
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") {
            
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    @objc func facebookEULA() {
        
        print("EULA")
    
        let webVC = TermsViewController()
        
        self.show(webVC, sender: nil)
        
    }
    
}
