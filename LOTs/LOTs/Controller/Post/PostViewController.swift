//
//  PostViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Kingfisher
import KeychainSwift
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class PostViewController: UIViewController {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var location: String?
    var cuisine: String?
    var createdTime: Int?
    var instagram: Bool?
    var articleTitle: String?
    var content: String?
    var picture: UIImage?
    var height: CGFloat?
    var width: CGFloat?
    var pictureURL: String?
    let keychain = KeychainSwift()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        articleImage.image = UIImage(named: "imageDefault")
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleImage.contentMode = .scaleAspectFill
        articleImage.corner(corner: 17.5)
        
        ref = Database.database().reference()
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostInfoCell")
        
        let nib2 = UINib(nibName: "ContentTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "ContentCell")

        articleImage.layer.cornerRadius = 8
        profileImage.cornerBorder()

        let profileUrl = URL(string: Auth.auth().currentUser?.photoURL?.absoluteString ?? "")
        profileImage.kf.setImage(with: profileUrl)

        tableView.dataSource = self
        tableView.delegate = self
        
        uploadPicture()
        
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    // Post Action
    @IBAction func postAction(_ sender: Any) {
        
        handleRegister()
//        backToMainPage()

    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        emptyData()
//        dismiss(animated: true, completion: nil)
    
    }
    
    func emptyData() {
        
        
        
    }
    
    func uploadPicture() {
        
        articleImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        articleImage.isUserInteractionEnabled = true
            
    }
    
    func backToMainPage() {
        
        let tabController = self.view.window!.rootViewController as? UITabBarController
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        tabController?.selectedIndex = 0
        
    }

}

extension PostViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 2

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == 0 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCell", for: indexPath) as? PostTableViewCell else {

                return UITableViewCell()

            }
            
            cell.dateCompletion = { (data : Int) -> Void in
                
                self.createdTime = data
                
                print("createdTime: \(data)")
                
            }
            
            cell.locationCompletion = { (data : String) -> Void in
                
                self.location = data
                
                print("location: \(data)")
            }
            
            cell.cuisineCompletion = { (data : String) -> Void in
                
                self.cuisine = data
                
                print("cuisine: \(data)")
            }
            
            return cell

        } else if indexPath.section == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as? ContentTableViewCell else {
                
                return UITableViewCell()

            }
            
            cell.contentTextView.delegate = self
            cell.titleTextField.delegate = self
            
            return cell
            
        }

        return UITableViewCell()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
    }
    
}

extension PostViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }

}

extension PostViewController: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        content = textView.text
        print("content: \(content)")
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.text = ""
        
    }
    
}

extension PostViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        articleTitle = textField.text ?? ""
        //        title = textField.text
        print("article: \(articleTitle)")
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textField.text = ""
        
    }
    
}
