//
//  LoginViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/25.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
