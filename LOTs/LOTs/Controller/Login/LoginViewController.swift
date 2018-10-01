//
//  LoginViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/25.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit

class LoginViewController: UIViewController {

    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var googleLoginButton: UIButton!
    @IBOutlet weak var guestModeButton: UIButton!
    @IBOutlet weak var facebookImage: UIImageView!
    @IBOutlet weak var googleImage: UIImageView!
    
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
                print("Failed to login: \(error?.localizedDescription)")
                return
            }
            
            guard result != nil else {
                print(result.debugDescription)
                return
            }
            
            guard let accessToken = result?.token.tokenString else {
                print("Failed to get access token")
                return
            }
            
//            print("ID:\(String(describing: result?.token.appID)), Token:\(String(describing: accessToken))")
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
            
            Auth.auth().signInAndRetrieveData(with: credential, completion: { (result, error) in
                
                if let error = error {
                    
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainPage") {
                    
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
            })

//            print(Auth.auth().currentUser?.displayName)
//            print(Auth.auth().currentUser?.photoURL?.absoluteString)
            
        }
        
    }
    
}
