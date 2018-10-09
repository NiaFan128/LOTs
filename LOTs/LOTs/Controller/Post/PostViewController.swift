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
    var articleID: String?
    var articleTitle: String?
    var content: String?
    var picture: UIImage?
    var height: CGFloat?
    var width: CGFloat?
    var pictureURL: String?
    let keychain = KeychainSwift()

    var editArticle: Article?

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
        
        if editArticle != nil {
            readEditData()
            
            let url = URL(string: editArticle?.articleImage ?? "")
            articleImage.kf.setImage(with: url)
            
        }
        
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func readEditData() {
        
        articleID = editArticle?.articleID ?? ""
        location = editArticle?.location
        cuisine = editArticle?.cuisine
        createdTime = editArticle?.createdTime
        articleTitle = editArticle?.articleTitle
        content = editArticle?.content
        pictureURL = editArticle?.articleImage
        
    }
    
    // Post Action
    @IBAction func postAction(_ sender: Any) {
        
        if editArticle != nil {
        
            editAction()
        
        }
        
        handleRegister()

    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        if editArticle != nil {
        
            navigationController?.popViewController(animated: true)
            
        }
        
    }
    
    class func editForArticle(_ article: Article) -> PostViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let editViewController = storyboard.instantiateViewController(withIdentifier: "selectPage") as? PostViewController else {
            return PostViewController()
        }
        
        editViewController.editArticle = article
        
        return editViewController
        
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

        switch indexPath.section {
            
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostInfoCell", for: indexPath) as? PostTableViewCell else {
                return UITableViewCell()
            }
            
            if editArticle != nil {
                
                cell.dateChange(createdTime)
                cell.locationChange(location)
                cell.cuisineChange(cuisine)
            
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
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as? ContentTableViewCell else {
                return UITableViewCell()
            }
            
            if editArticle != nil {
            
                cell.titleTextField.text = editArticle?.articleTitle
                cell.contentTextView.text = editArticle?.content
//                cell.contentCancelButton.addTarget(self, action: #selector(getter: ContentTableViewCell.contentCancelButton), for: .touchUpInside)
                cell.contentCancelButton.isHidden = false
            }
            
            cell.contentCancelButton.isHidden = true
            cell.titleTextField.delegate = self
            cell.contentTextView.delegate = self

            return cell
            
        default: break
            
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

extension PostViewController: UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        articleTitle = textField.text ?? ""
        print("article: \(articleTitle)")
        
    }
    
}

extension PostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        //        if editArticle != nil {
        //
        //            textView.text = editArticle?.content
        //
        //        }
        
        //        textView.text = ""
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
//        if editArticle != nil {
//
//
//
//        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        content = textView.text ?? ""
        print("content: \(content)")
        
    }
    
}
