//
//  LikeDetailViewController.swift
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

class LikeDetailViewController: UIViewController {

    @IBOutlet weak var likeDetailTableView: UITableView!
    
    var article: Article!
    var articles = [Article]()
    var location: String = ""
    var ref: DatabaseReference!
    let keychain = KeychainSwift()
    let decoder = JSONDecoder()
    var uid: String = ""
    
    var fullScreenSize: CGSize!
    let animationView = LOTAnimationView(name: "lunch_time")
    var animationLabel = UILabel()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        fullScreenSize = UIScreen.main.bounds.size
        animationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: fullScreenSize.width, height: 21))
        
        let nib = UINib(nibName: "LikeDetailTableViewCell", bundle: nil)
        likeDetailTableView.register(nib, forCellReuseIdentifier: "LikeDetailCell")

        likeDetailTableView.delegate = self
        likeDetailTableView.dataSource = self
        
        ref = Database.database().reference()
        uid = self.keychain.get("uid") ?? ""

        self.navigationItem.title = location
        
        self.likeArticle(location)
        
        NotificationCenter.default.addObserver(self, selector: #selector(removeFromLike(notification:)), name: Notification.Name("Remove"), object: nil)
        
    }
    
    // Need to fix since didn't receive the notification
    @objc func removeFromLike(notification: Notification) {
        
        guard let data = notification.userInfo as? [String: String] else { return }
        guard let articleID = data["articleID"] else { return }
        guard let location = data["location"] else { return }

        print("articleID: \(articleID), location: \(location)")
        
        ref.child("likes/\(uid)").child("\(location)").child(articleID).removeValue()

        
    }

    // Retrieve the personal like posts and filter by location
    func likeArticle(_ location: String) {
        
        ref.child("likes/\(uid)").queryOrderedByKey().queryEqual(toValue: location).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let value = snapshot.value as? NSDictionary else { return }

            for localValue in value.allValues {

                guard let dictionaryData = localValue as? NSDictionary else { return }

                let articleArray = dictionaryData.allKeys

                for articleID in articleArray {
                    
                    self.readArticleData(articleID as! String)

                }

            }

        })
        
    }
    
    // Read data according to the articleID
    func readArticleData(_ articleID: String) {
        
        articles = []
        
        ref.child("posts").queryOrderedByKey().queryEqual(toValue: articleID).observeSingleEvent(of: .value) { (snapshot) in
            
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
            
            self.likeDetailTableView.reloadData()
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false

    }
    
    class func likeDetailViewControllerFromLocation(_ location: String) -> LikeDetailViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "LikeDetail") as? LikeDetailViewController else {
            
            return LikeDetailViewController()
            
        }
        
        viewController.location = location
        
        return viewController
        
    }
    
    func showNoDataAnimation() {
        
        animationView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        animationView.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5) - 50)
        
        animationView.contentMode = .scaleAspectFit
        
        view.addSubview(animationView)
        
        animationView.play()
        animationView.loopAnimation = false
        
        animationLabel.center = CGPoint(x: (fullScreenSize.width * 0.5), y: (fullScreenSize.height * 0.5) + 20)
        animationLabel.textAlignment = .center
        animationLabel.text = "There is no related article now."
        animationLabel.textColor = #colorLiteral(red: 0.8274509804, green: 0.3529411765, blue: 0.4, alpha: 1)
        
        view.addSubview(animationLabel)
        
    }
    
    func removeAnimation() {
        
        animationView.removeFromSuperview()
        animationLabel.removeFromSuperview()
        
    }
    
}

extension LikeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if articles.count != 0 {
            
            self.removeAnimation()
            
        } else {
            
            self.showNoDataAnimation()
            
        }
        
        return articles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LikeDetailCell", for: indexPath) as? LikeDetailTableViewCell else {

            return UITableViewCell()

        }

        let article = articles[indexPath.row]
        
        cell.authorLabel.text = article.user.name
        
        let userUrl = URL(string: article.user.image)
        cell.authorImage.kf.setImage(with: userUrl)
        
        let articleUrl = URL(string: article.articleImage)
        cell.articleImage.kf.setImage(with: articleUrl)
        
        cell.articleTitleLabel.text = article.articleTitle
        cell.cuisineLabel.text = article.cuisine

        return cell

    }
    
}

extension LikeDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let article: Article = articles[indexPath.row]
        
        let detailViewController = DetailViewController.detailViewControllerForArticle(article)

        navigationController?.pushViewController(detailViewController, animated: true)
        
    }


}
