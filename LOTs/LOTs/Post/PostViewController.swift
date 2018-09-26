//
//  PostViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class PostViewController: UIViewController {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profileImage: UIImageView!
    
    var ref: DatabaseReference!
    var location: String = ""
    var cuisine: String = ""
    var createdTime: String = ""
    var instagrame: Bool?
    var content: String = ""
    var picture: UIImage?
    var height: CGFloat?
    var width: CGFloat?
    var pictureURL: String?

    var writeResults = [[String: Any]]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        ref = Database.database().reference()
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostInfoCell")
        
        let nib2 = UINib(nibName: "ContentTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "ContentCell")
        
        articleImage.layer.cornerRadius = 8
        profileImage.layer.cornerRadius = 17.5
        profileImage.image = UIImage(named: "profile_1")

        tableView.dataSource = self
        tableView.delegate = self
        
        uploadPicture()
        
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    // Post Action
    @IBAction func postAction(_ sender: Any) {
        
        handleRegister()
        saveContent()
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
                
        titleTextField.text = ""
        
    }
    
    // Will update after completing the login function
    func uploadPicture() {
        
        articleImage.image = UIImage(named: "imageDefault")
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleImage.contentMode = .scaleAspectFill
//        articleImage.layer.cornerRadius = 17.5

        articleImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        articleImage.isUserInteractionEnabled = true
            
    }
    
    func saveContent() {
        
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
            
            cell.dateCompletion = { (data : String) -> Void in
                
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        textView.text = ""
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        print(textView.text)
        
        content = textView.text
        
    }

}
