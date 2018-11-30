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
import FBSDKLoginKit
import KeychainSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var animationBGView: UIView!
    @IBOutlet weak var loginView: UIView!
    
    var fullScreenSize: CGSize!
    var animationScreenSize: CGSize!
    let animationView = LOTAnimationView(name: "list")
    let userAnimationView = LOTAnimationView(name: "user")
    var animationLabel = UILabel()
    var userAnimationLabel = UILabel()
    
    var article: Article!
    var articles = [Article]()
    
    var ref: DatabaseReference!
    let decoder = JSONDecoder()
    let keychain = KeychainSwift()
    
    var uid: String?
    var userName: String = ""
    var imageUrl: String = ""
    let manager = FirebaseManager()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        fullScreenSize = UIScreen.main.bounds.size
        animationScreenSize = animationBGView.bounds.size
        animationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: 21))
        userAnimationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: 40))

        self.layoutSetup()
        
        let nib = UINib(nibName: "ProfileTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ProfileACell")
        
        let nib2 = UINib(nibName: "ProfileCollectionViewCell", bundle: nil)
        collectionView.register(nib2, forCellWithReuseIdentifier: "ProfileBCell")

        ref = Database.database().reference()
        userName = self.keychain.get("name") ?? ""
        imageUrl = self.keychain.get("imageUrl") ?? ""
        uid = self.keychain.get("uid")
        
        if uid != nil {
            
            loginView.isHidden = true
            emptyView.isHidden = true
            animationBGView.isHidden = false
            
        } else {
            
            loginView.isHidden = false
            self.emptyView.isHidden = false
            self.animationBGView.isHidden = true
            
        }
        
        self.userArticle()
        
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
        
        guard let uid = self.keychain.get("uid") else { return }

        manager.getQueryOrderEqual(path: "posts", order: "user/uid", equalTo: uid, event: .valueChange, success: { (data) in
            
            guard let articleData = data as? Article else { return }
            
            self.articles.append(articleData)
            
            self.collectionView.reloadData()
            self.tableView.reloadData()
            
        }, failure: { _ in
            
        })
        
    }
    
    func showNoDataAnimation() {

        animationView.frame = CGRect(x: 0, y: 0, width: 250, height: 250)
        animationView.center = CGPoint(x: (animationBGView.frame.width) * 0.5, y: (animationBGView.frame.height * 0.5))
        animationView.contentMode = .scaleAspectFit
        animationBGView.addSubview(animationView)
        
        animationView.play()
        animationView.animationSpeed = 1.5
        animationView.loopAnimation = false

        animationLabel.center = CGPoint(x: (animationBGView.frame.width * 0.5), y: (animationBGView.frame.height * 0.5) + 50)
        animationLabel.textAlignment = .center
        animationLabel.text = "You haven't posted any article yet."
        animationLabel.textColor = #colorLiteral(red: 0.8274509804, green: 0.3529411765, blue: 0.4, alpha: 1)
        
        animationBGView.addSubview(animationLabel)
        
    }
    
    func removeAnimation() {
        
        animationView.removeFromSuperview()
        animationLabel.removeFromSuperview()
        
    }
    
    func logoutAlertReminder(_ userName: String) {
                
        let alertController = UIAlertController(title: "Oops!", message: "Dear \(userName),\n Are you sure to log out? 😢 ", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Confirm", style: .default, handler: { (_) in
            
            self.keychain.clear()
            
            FBSDKLoginManager().logOut()
            
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            
            UIApplication.shared.keyWindow?.rootViewController = loginViewController
            self.dismiss(animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            
        })
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
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
        
        cell.updateCellInfo(ProfileCellModel(name: userName, image: imageUrl, posts: String(articles.count)))
        cell.buttonDelegate = self
        cell.selectionStyle = .none

        return cell
        
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 290
        
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

extension ProfileViewController: LogoutButton {
    
    func buttonSelect(_ button: UIButton) {
        
        logoutAlertReminder(userName)
        
    }
    
}
