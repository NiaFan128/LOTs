//
//  LoginViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/25.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {

    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var GuestModeButton: UIButton!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var googleImage: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        facebookLoginButton.layer.cornerRadius = 7
        googleLoginButton.layer.cornerRadius = 7
        GuestModeButton.layer.cornerRadius = 7
        
        facebookImage.image = facebookImage.image?.withRenderingMode(.alwaysTemplate)
        facebookImage.tintColor = UIColor.init(red: 250.0/255.0, green: 145.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        
        googleImage.image = googleImage.image?.withRenderingMode(.alwaysTemplate)
        googleImage.tintColor = UIColor.init(red: 250.0/255.0, green: 145.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        
        
    }
    
    @IBAction func facebookLogin(_ sender: Any) {
        
        let fbLoginManager = FBSDKLoginManager()
        
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            guard result != nil else {
                print(result.debugDescription)
                return
            }
            
            guard let tokenString = result?.token.tokenString else {
                return
            }
            
            print("ID:\(String(describing: result?.token.appID)), Token:\(String(describing: tokenString))")
//            print(Auth.auth().currentUser?.displayName)
//            print(Auth.auth().currentUser?.photoURL?.absoluteString)
            
        }
        
    }
    
}
