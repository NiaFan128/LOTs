//
//  PostViewController+handler.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/22.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseAuth
import FirebaseStorage
import KeychainSwift

extension PostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func postNewArticle() {
        
        // Error Handler
        guard location != nil else {
            alertRemind("location")
            return
        }
        
        guard cuisine != nil else {
            alertRemind("cuisine")
            return
        }

        guard createdTime != nil else {
            alertRemind("time")
            return
        }

        guard articleTitle != nil else {
            alertRemind("article title")
            return
        }

        guard content != nil else {
            alertRemind("content")
            return
        }
        
        guard articleImage.image != UIImage(named: "imageDefault") else {
            alertRemind("image")
            return
        }
        
        doneBarButton.isEnabled = false
        self.showLoadingAnimation()
        
        let fileName = UUID().uuidString
        
        // Storage
        let storageRef = Storage.storage().reference().child("article_images").child("\(fileName).jpg")
        
        if let articleImage = self.articleImage.image, let uploadData = self.articleImage.image?.jpegData(compressionQuality: 0.5) {
            
            height = articleImage.size.height
            width = articleImage.size.width
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            storageRef.putData(uploadData, metadata: metaData) { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in

                    guard let downloadURL = url else { return }
                    
                    self.pictureURL = downloadURL.absoluteString
                    
                    guard let postID = self.ref.child("post").childByAutoId().key else { return }
                    guard let uid = self.keychain.get("uid") else { return }
                    guard let profileURL = self.keychain.get("imageUrl") else { return }
                    
                    self.ref.child("posts/\(postID)").setValue([
                        "articleID": postID,
                        "articleTitle": self.articleTitle,
                        "articleImage": self.pictureURL,
                        "height": self.height,
                        "width": self.width,
                        "createdTime": self.createdTime,
                        "cuisine": self.cuisine,
                        "location": self.location,
                        "content": self.content,
                        "interestedIn": false,
                        "user":
                            [
                                "name": Auth.auth().currentUser?.displayName,
                                "image": profileURL,
                                "uid": uid
                            ]
                        ])
                })
                
                self.flag = true
                self.cleanData()
                self.doneBarButton.isEnabled = true
                self.backToMainPage()
                
            }
            
        }
                
    }
    
    func editAction() {
        
        // Error Handler
        guard location != nil else {
            alertRemind("location")
            return
        }
        
        guard cuisine != nil else {
            alertRemind("cuisine")
            return
        }
        
        guard createdTime != nil else {
            alertRemind("time")
            return
        }
        
        guard articleTitle != nil else {
            alertRemind("article title")
            return
        }
        
        guard content != nil else {
            alertRemind("content")
            return
        }
        
        guard articleID != nil else {
            return
        }
        
        guard articleImage.image != UIImage(named: "imageDefault") else {
            alertRemind("image")
            return
        }
        
        doneBarButton.isEnabled = false
        
        self.showLoadingAnimation()
        
        let fileName = UUID().uuidString
        
        let storageRef = Storage.storage().reference().child("article_images").child("\(fileName).jpg")
        
        if let articleImage = self.articleImage.image, let uploadData = self.articleImage.image?.jpegData(compressionQuality: 0.5) {
            
            height = articleImage.size.height
            width = articleImage.size.width
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            
            storageRef.putData(uploadData, metadata: metaData) { (metadata, error) in
                
                if error != nil {
                    print(error)
                    return
                }
                                
                storageRef.downloadURL(completion: { (url, error) in
                    
                    guard let downloadURL = url else { return }
                    self.pictureURL = downloadURL.absoluteString
                    guard let uid = self.keychain.get("uid") else { return }
                    guard let articleID = self.articleID else { return }
                    guard let profileURL = self.keychain.get("imageUrl") else { return }

                    self.ref.child("posts/\(articleID)").updateChildValues([
            
                        "articleID": articleID,
                        "articleTitle": self.articleTitle,
                        "articleImage": self.pictureURL,
                        "height": self.height,
                        "width": self.width,
                        "createdTime": self.createdTime,
                        "cuisine": self.cuisine,
                        "location": self.location,
                        "content": self.content,
                        "interestedIn": false,
                        "user":
                            [
                                "name": Auth.auth().currentUser?.displayName,
                                "image": profileURL,
                                "uid": uid
                        ]
                        
                    ])
                    
                    self.delegate?.readUpdateData()
                    self.doneBarButton.isEnabled = true
                    self.cleanData()
                    self.navigationController?.popViewController(animated: true)

                })
            }

        }
        
    }
    
    func alertRemind(_ status: String) {
        
        AlertView.showAlert(view: self, title: "Remind", message: "Please complete \(status) part!")
        
    }
        
    func handleSelectImage() {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            selectImageFromPicker = editedImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectImageFromPicker = originalImage

        }
        
        if let selectedImage = selectImageFromPicker {
            
            articleImage.image = selectedImage
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
