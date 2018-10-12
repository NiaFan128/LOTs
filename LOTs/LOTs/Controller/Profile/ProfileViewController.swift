//
//  ProfileViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Lottie
import Firebase
import Kingfisher
import KeychainSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var animationBGView: UIView!
    
    var fullScreenSize: CGSize!
//    var articleImage = [UIImage]()
//    let animationView = LOTAnimationView(name: "profile")
    let animationView = LOTAnimationView(name: "list")
    let userAnimationView = LOTAnimationView(name: "user")
    
    var animationLabel = UILabel()
    var userAnimationLabel = UILabel()
    
    var article: Article!
    var articles = [Article]()
    var ref: DatabaseReference!
    let keychain = KeychainSwift()
    var uid: String = ""
    var userName: String = ""
    var imageUrl: String = ""
    var visitor: String = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        fullScreenSize = UIScreen.main.bounds.size
        animationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: 21))
        userAnimationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: 40))

        self.layoutSetup()
        
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProfileACell")
        
        let nib2 = UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
        collectionView.register(nib2, forCellWithReuseIdentifier: "ProfileBCell")

        ref = Database.database().reference()
        uid = self.keychain.get("uid") ?? ""
        userName = self.keychain.get("name") ?? ""
        imageUrl = self.keychain.get("imageUrl") ?? ""
        visitor = self.keychain.get("visitor") ?? ""
        
        if visitor == "visitor" {
            
            self.emptyView.isHidden = false
            self.showLoginAnimation()
            self.animationBGView.isHidden = true
            
        } else {
            
            emptyView.isHidden = true
            animationBGView.isHidden = false
            
        }
        
//        self.userArticle()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func layoutSetup() {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 7.5, left: 5, bottom: 7.5, right: 5)
        layout.minimumLineSpacing = 7.5
        layout.minimumInteritemSpacing = 7.5
        layout.itemSize = CGSize(width: CGFloat(fullScreenSize.width) / 3 - 10, height: CGFloat(fullScreenSize.width) / 3 - 10)
        
        collectionView.collectionViewLayout = layout
        
    }
    
    func userArticle() {
        
        ref.child("posts").queryOrdered(byChild: "user/uid").queryEqual(toValue: uid).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            for key in value.allKeys {
                
                guard let data = value[key] as? NSDictionary else { return }
                guard let user = data["user"] as? NSDictionary else { return }
                guard let articleID = data["articleID"] as? String else { return }
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
                
                let article = Article(articleID: articleID, articleTitle: articleTitle, articleImage: articleImage, height: 0, width: 0, createdTime: createdTime, location: location, cuisine: cuisine, content: content, user: User(name: userName, image: userImage, uid: uid), instagramPost: false, interestedIn: interestedIn)
                
                self.articles.append(article)
                                
            }
            
            self.collectionView.reloadData()
            self.tableView.reloadData()
            
        }
        
    }

    func showLoginAnimation() {
        
        userAnimationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        userAnimationView.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5) - 70)
        userAnimationView.contentMode = .scaleAspectFit
        
        emptyView.addSubview(userAnimationView)
        
        userAnimationView.play()
        userAnimationView.animationSpeed = 1.5
        userAnimationView.loopAnimation = false
        
        userAnimationLabel.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5))
        userAnimationLabel.textAlignment = .center
        userAnimationLabel.numberOfLines = 0
        userAnimationLabel.text = "Please login with Facebook."
        userAnimationLabel.textColor = #colorLiteral(red: 0.8274509804, green: 0.3529411765, blue: 0.4, alpha: 1)
        
        emptyView.addSubview(userAnimationLabel)
        
    }
    
    func showNoDataAnimation() {

        animationView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        animationView.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5))
        animationView.contentMode = .scaleAspectFit
        animationBGView.addSubview(animationView)
        
        animationView.play()
        animationView.animationSpeed = 1.5
        animationView.loopAnimation = false

        animationLabel.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5) + 50)
        animationLabel.textAlignment = .center
        animationLabel.text = "You haven't posted any article yet."
        animationLabel.textColor = #colorLiteral(red: 0.8274509804, green: 0.3529411765, blue: 0.4, alpha: 1)
        
        animationBGView.addSubview(animationLabel)
        
    }
    
    func removeAnimation() {
        
        animationView.removeFromSuperview()
        animationLabel.removeFromSuperview()
        
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
        
        DispatchQueue.main.async {
            
            cell.authorLabel.text = self.userName
            let userUrl = URL(string: self.imageUrl)
            cell.profileImage.kf.setImage(with: userUrl)
            cell.postsAmountLabel.text = String(self.articles.count)
        
        }
        
        return cell
        
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 280

//        return UITableView.automaticDimension
        
    }
    
}

extension ProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let article: Article = articles[indexPath.row]
        
        let detailViewController = DetailViewController.detailViewControllerForArticle(article)
        navigationController?.pushViewController(detailViewController, animated: true)
        
    }
    
}

extension ProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if articles.count == 0 {
            
//            animationBGView.isHidden = false
            showNoDataAnimation()
            
        } else {
            
            removeAnimation()
            animationBGView.isHidden = true
            
        }
        
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
