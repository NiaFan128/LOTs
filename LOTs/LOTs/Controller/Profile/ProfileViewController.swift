//
//  ProfileViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import KeychainSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var fullScreenSize: CGSize!
    var articleImage = [UIImage]()
    
//    var article: Article!
    var articles = [Article]()
    var ref: DatabaseReference!
    let keychain = KeychainSwift()
    var uid: String = ""
    var userName: String = ""
    var imageUrl: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        fullScreenSize = UIScreen.main.bounds.size
        
        self.layoutSetup()
        
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProfileACell")
        
        let nib2 = UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
        collectionView.register(nib2, forCellWithReuseIdentifier: "ProfileBCell")

        ref = Database.database().reference()
        uid = self.keychain.get("uid") ?? ""
        userName = self.keychain.get("name") ?? ""
        imageUrl = self.keychain.get("imageUrl") ?? ""
        
        self.likeArticle()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func layoutSetup() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 7.5, left: 5, bottom: 7.5, right: 5)
        layout.minimumLineSpacing = 7.5
        layout.minimumInteritemSpacing = 7.5
        //        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: CGFloat(fullScreenSize.width) / 3 - 10, height: CGFloat(fullScreenSize.width) / 3 - 10)
        
        collectionView.collectionViewLayout = layout
        
    }
    
    func likeArticle() {
        
        ref.child("posts").queryOrdered(byChild: "user/uid").queryEqual(toValue: uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            print(value)
            
            for key in value.allKeys {
                
                guard let data = value[key] as? NSDictionary else { return }
                guard let user = data["user"] as? NSDictionary else { return }
                guard let articleTitle = data["articleTitle"] as? String else { return }
                guard let articleImage = data["articleImage"] as? String else { return }
                guard let cuisine = data["cuisine"] as? String else { return }
                guard let userName = user["name"] as? String else { return }
                guard let userImage = user["image"] as? String else { return }
                guard let uid = user["uid"] as? String else { return }
                guard let location = data["location"] as? String else { return }
                guard let createdTime = data["createdTime"] as? Int else { return }
                guard let content = data["content"] as? String else { return }
                guard let interestedIn = data["interestedIn"] as? Bool else { return }
                
                let article = Article(articleTitle: articleTitle, articleImage: articleImage, height: 0, width: 0, createdTime: createdTime, location: location, cuisine: cuisine, content: content, user: User(name: userName, image: userImage, uid: uid), instagramPost: false, interestedIn: interestedIn)
                
                self.articles.append(article)
                                
            }
            
            self.collectionView.reloadData()
            self.tableView.reloadData()
            
        }
        
    }
    
}

extension ProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileACell", for: indexPath) as? ProfileTableViewCell else {
            
            return UITableViewCell()
            
        }
        
        cell.authorLabel.text = userName
        let userUrl = URL(string: imageUrl)
        cell.profileImage.kf.setImage(with: userUrl)
        
        DispatchQueue.main.async {
            
            cell.postsAmountLabel.text = String(self.articles.count)
        
        }
        
        return cell
        
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 140

//        return UITableView.automaticDimension
        
    }
    
}

extension ProfileViewController: UICollectionViewDelegate {
    
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return articles.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileBCell", for: indexPath) as? ProfileCollectionViewCell else {
            
            return UICollectionViewCell()
            
        }
        
        let article = articles[indexPath.row]
        
        let articleUrl = URL(string: article.articleImage)
        cell.articleImage.kf.setImage(with: articleUrl)
        
        return cell
        
    }

}
