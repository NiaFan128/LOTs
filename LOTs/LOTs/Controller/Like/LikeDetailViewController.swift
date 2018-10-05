//
//  LikeDetailViewController.swift
//  LOTs
//
//  Created by 乃方 on 2018/9/26.
//  Copyright © 2018年 Nia. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class LikeDetailViewController: UIViewController {

    @IBOutlet weak var likeDetailTableView: UITableView!
    
    var article: Article!
    var articles = [Article]()
    var ref: DatabaseReference!
    let decoder = JSONDecoder()
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        let nib = UINib(nibName: "LikeDetailTableViewCell", bundle: nil)
        likeDetailTableView.register(nib, forCellReuseIdentifier: "LikeDetailCell")

        likeDetailTableView.delegate = self
        likeDetailTableView.dataSource = self
        ref = Database.database().reference()
        
        self.readLocation()
        
    }

    func readLocation() {
        
        ref.child("posts").queryOrdered(byChild: "location").queryEqual(toValue: "中正區").observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value as? NSDictionary else { return }
            
            for key in value.allKeys {
                
                guard let data = value[key] as? NSDictionary else { return }
                guard let user = data["user"] as? NSDictionary else { return }
                guard let articleTitle = data["articleTitle"] as? String else { return }
                guard let articleImage = data["articleImage"] as? String else { return }
                guard let cuisine = data["cuisine"] as? String else { return }
                guard let userName = user["name"] as? String else { return }
                guard let userImage = user["image"] as? String else { return }
                guard let location = data["location"] as? String else { return }
                guard let createdTime = data["createdTime"] as? Int else { return }
                guard let content = data["content"] as? String else { return }

                let article = Article(articleTitle: articleTitle, articleImage: articleImage, height: 0, width: 0, createdTime: createdTime, location: location, cuisine: cuisine, content: content, user: User(name: userName, image: userImage), instagramPost: false)
                
                self.articles.append(article)
                
            }

            self.likeDetailTableView.reloadData()
            
        }
        
    }
    
//     Codable QQ
//        func readLocation() {
//    
//            ref.child("posts").queryOrdered(byChild: "location").queryEqual(toValue: "中正區").observeSingleEvent(of: .childAdded) { (snapshot) in
//    
//                guard let value = snapshot.value as? NSDictionary else { return }
//    
//                guard let locationJSONData = try? JSONSerialization.data(withJSONObject: value) else { return }
//    
//                do {
//    
//                    let locationData = try self.decoder.decode(Article.self, from: locationJSONData)
//                    self.articles.append(locationData)
//                    print(self.articles)
//    
//                } catch {
//    
//                    print(error)
//    
//                }
//    
//            }
//    
//        }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(true)
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false

    }
    
    class func likeDetailViewControllerForLike() -> LikeDetailViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "LikeDetail") as? LikeDetailViewController else {
            
            return LikeDetailViewController()
            
        }
        
//        viewController.article = article
        
        return viewController
        
    }
    
}

extension LikeDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
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

        let row = indexPath.row

        if row == 0 {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)

            let detailViewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController")

//            let detailViewController = DetailViewController.detailViewControllerForArticle()
//            navigationController?.pushViewController(detailViewController, animated: true)
            
            show(detailViewController, sender: nil)

        }

    }


}
