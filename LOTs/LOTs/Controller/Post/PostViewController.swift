//
//  PostViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/20.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Lottie
import Kingfisher
import KeychainSwift
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

protocol EditUpdateProtocol: AnyObject {

    func readUpdateData()
    
}

class PostViewController: UIViewController {

    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
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
    
    var fullScreenSize: CGSize!
    let animationBGView: UIView = UIView()
    let animationView = LOTAnimationView(name: "loading_2")

    weak var delegate: EditUpdateProtocol?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        pictureSetUp()
        pictureDefault()
            
        ref = Database.database().reference()
        fullScreenSize = UIScreen.main.bounds.size
    
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "PostInfoCell")
        
        let nib2 = UINib(nibName: "ContentTableViewCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "ContentCell")

        tableView.dataSource = self
        tableView.delegate = self

        view.addSubview(animationBGView)
        animationBGView.isHidden = true
        animationBGView.frame = CGRect(x: 0, y: 0, width: fullScreenSize.width, height: fullScreenSize.height)
        
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
    
    func pictureSetUp() {
        
        articleImage.layer.cornerRadius = 8
        profileImage.cornerBorder()
        
        let profileUrl = URL(string: Auth.auth().currentUser?.photoURL?.absoluteString ?? "")
        profileImage.kf.setImage(with: profileUrl)
        
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
    
    func showLoadingAnimation() {
        
        animationBGView.isHidden = false
        animationBGView.backgroundColor = .white
        animationBGView.alpha = 0.6
        animationView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        animationView.center = CGPoint(x: (view.frame.width * 0.5), y: (view.frame.height * 0.5))
        animationView.contentMode = .scaleAspectFill
        
        animationBGView.addSubview(animationView)
        
        animationView.play()
        animationView.loopAnimation = true
        
    }
    
    @IBAction func postAction(_ sender: Any) {
        
        if editArticle != nil {
        
            self.editAction()

        } else {
            
            postNewArticle()
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
        
        animationBGView.isHidden = true
        
        let tabController = self.view.window!.rootViewController as? UITabBarController
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        tabController?.selectedIndex = 0
        
    }
    
    func cleanData() {
        
        pictureDefault()
        self.tableView.reloadData()
        
    }
    
    
    @objc func photoSource() {
        
        AlertView.uploadImage(self, title: "Upload Image", message: nil,
                              firstHandler: { (_) in
                                
                                self.handleCamera()},
                              
                              secondHandler: { (_) in
                                
                                self.handleSelectImage()
                                
        })
        
    }
    
    func handleCamera() {
        
        let storyboard = UIStoryboard(name: "Camera", bundle: nil)
        
        guard let cameraViewController = storyboard.instantiateViewController(withIdentifier: "Camera") as? CameraViewController else { return }
        
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
                
                cell.dateCompletion = { (data) in
                    
                    self.createdTime = data
                    
                }
                
                cell.locationCompletion = { (data) in
                    
                    self.location = data
                    
                }
                
                cell.cuisineCompletion = { (data) in
                    
                    self.cuisine = data
                    
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
            
            cell.selectionStyle = .none

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
        
    }
    
}

extension PostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if editArticle != nil {

            textView.text = editArticle?.content
            textView.textColor = UIColor.black

        } else {

            textView.textColor = UIColor.black

        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        content = textView.text ?? ""
        textView.textColor = UIColor.black
        
    }
    
}

extension PostViewController: SaveCameraPhotoProtocol {
    
    func savePhotoImage(_ photo: UIImage) {
        
        articleImage.image = photo
        
    }

}
