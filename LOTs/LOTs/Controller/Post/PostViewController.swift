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

protocol EditUpdate: AnyObject {

    func readUpdateData()
    
}

class PostViewController: UIViewController {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginView: UIView!

    var ref: DatabaseReference!
    let keychain = KeychainSwift()
    
    var location: String?
    var cuisine: String?
    var createdTime: Int?
    var instagram: Bool?
    
    var articleID: String?
    var articleTitle: String?
    var content: String?
    var picture: UIImage?
    var photo: UIImage?
    var height: CGFloat?
    var width: CGFloat?
    var pictureURL: String?

    var editArticle: Article?
    var uid: String?
    let now: Date = Date()
    var flag = true
        
    weak var delegate: EditUpdate?

    override func viewDidLoad() {
        
        super.viewDidLoad()

        pictureDefault()

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
        
        uid = self.keychain.get("uid") 
        
        uploadPicture()
        
        if editArticle != nil {
            
            readEditData()
            
            let url = URL(string: editArticle?.articleImage ?? "")
            articleImage.kf.setImage(with: url)
            
        }
        
        if uid == nil {
            
            loginView.isHidden = false
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
            
        } else {
            
            loginView.isHidden = true
            
        }
        
        createdTime = Int(now.timeIntervalSince1970)
        
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
        
    func pictureDefault() {
        
        articleImage.image = UIImage(named: "imageDefault")
        articleImage.translatesAutoresizingMaskIntoConstraints = false
        articleImage.contentMode = .scaleAspectFill
        articleImage.corner(corner: 17.5)
        
    }
    
    func readEditData() {
        
        articleID = editArticle?.articleID
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
        
        } else {
            
            handleRegister()
    
        }

        view.endEditing(true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        if editArticle != nil {
        
            navigationController?.popViewController(animated: true)
            
        } else {
            
            flag = true
            cleanData()
            
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
        
        articleImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(photoSource)))
        articleImage.isUserInteractionEnabled = true
            
    }
    
    func backToMainPage() {
        
        let tabController = self.view.window!.rootViewController as? UITabBarController
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        tabController?.selectedIndex = 0
        
    }
    
    func cleanData() {
        
        pictureDefault()
        self.tableView.reloadData()
        
    }
    
    
    @objc func photoSource() {
        
        let alertController = UIAlertController(title: "Upload Image", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Take a Photo", style: .default) { (_) in
            
            self.handleCamera()
            
        }
        
        let libraryAction = UIAlertAction(title: "Select from Camera Roll", style: .default) { (_) in
            
            self.handleSelectImage()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in

        })
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func handleCamera() {
        
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        
        guard let cameraViewController = storyboard.instantiateViewController(withIdentifier: "Camera") as? CameraViewController else {
            
            return
            
        }
        
        cameraViewController.saveDelegate = self
        
        present(cameraViewController, animated: true, completion: nil)
        
    }
    
}

extension PostViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {

        return 2

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 1

    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
        
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
            
            } else if flag {
                
                cell.setUpValue()
                
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
                
            }
            
            cell.selectionStyle = .none
            
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as? ContentTableViewCell else {
                return UITableViewCell()
            }
            
            if editArticle != nil {
            
                cell.titleTextField.text = editArticle?.articleTitle
                cell.contentTextView.text = editArticle?.content

            } else if flag {
                
                cell.setUpValue()

                flag = false

            }
            
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

        if editArticle != nil {

            textView.text = editArticle?.content
            textView.textColor = UIColor.black

        } else {

//            textView.text = ""
            textView.textColor = UIColor.black

        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        content = textView.text ?? ""
        textView.textColor = UIColor.black
        print("content: \(content)")
        
    }
    
}

extension PostViewController: SaveCameraPhotoProtocol {
    
    func savePhotoImage(_ photo: UIImage) {
        
        articleImage.image = photo
        
    }

}
